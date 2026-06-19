import 'dart:convert';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/isar/offline_action.dart';
import '../main.dart'; // To access rootScaffoldMessengerKey

class OfflineSyncWorker {
  final Isar _isar;
  final SupabaseClient _sb;
  bool _isSyncing = false;
  late final StreamSubscription<List<ConnectivityResult>>
  _connectivitySubscription;

  OfflineSyncWorker(this._isar, this._sb) {
    // ดักจับการเปลี่ยนแปลงอินเทอร์เน็ต (ถ้าเน็ตกลับมา ให้ทำงานทันที)
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi)) {
        _processQueue();
      }
    });
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }

  /// เพิ่มคำสั่งเข้าคิว (เรียกใช้เมื่อแอปบันทึกข้อมูลไม่สำเร็จเพราะไม่มีเน็ต)
  Future<void> enqueueAction(
    String actionType,
    Map<String, dynamic> payload,
  ) async {
    final action =
        OfflineAction()
          ..actionType = actionType
          ..payloadJson = jsonEncode(payload)
          ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.offlineActions.put(action);
    });

    // ลองซิงก์เผื่อมีเน็ตเลย
    _processQueue();
  }

  void _showSnackBar(String message, {Color color = Colors.green}) {
    final messenger = rootScaffoldMessengerKey.currentState;
    if (messenger != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// เริ่มกระบวนการเคลียร์คิว (FIFO - First In, First Out)
  Future<void> _processQueue() async {
    if (_isSyncing) return; // ป้องกันการซิงก์ซ้อนทับกัน

    // เช็คว่ามีคิวเหลือไหมก่อนเริ่ม
    final pendingCount = await _isar.offlineActions.count();
    if (pendingCount == 0) return;

    _isSyncing = true;
    _showSnackBar(
      'กำลังส่งข้อมูลออฟไลน์ไปเก็บ...',
      color: Colors.amber.shade800,
    );

    try {
      // ดึงคิวทั้งหมดเรียงจากเก่าไปใหม่
      final actions =
          await _isar.offlineActions.where().sortByCreatedAt().findAll();

      for (final action in actions) {
        if (action.retryCount >= 5) {
          debugPrint('Dropping Zombie Action: ${action.id} after 5 retries');
          await _isar.writeTxn(() async {
            await _isar.offlineActions.delete(action.id);
          });
          continue;
        }

        final status = await _executeAction(action);

        if (status == _SyncStatus.success) {
          await _isar.writeTxn(() async {
            await _isar.offlineActions.delete(action.id);
          });
        } else if (status == _SyncStatus.temporaryError) {
          // ถ้าเน็ตพัง ให้หยุดลูปทันที
          break;
        } else {
          await _isar.writeTxn(() async {
            action.retryCount += 1;
            action.lastError = 'Sync Failed at ${DateTime.now()}';
            await _isar.offlineActions.put(action);
          });
        }
      }

      final remainingCount = await _isar.offlineActions.count();
      if (remainingCount == 0) {
        debugPrint('All offline actions synced successfully.');
      }
    } catch (e) {
      debugPrint('Sync Worker Error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// จำแนก Action Type ว่าต้องส่งข้อมูลแบบไหน
  Future<_SyncStatus> _executeAction(OfflineAction action) async {
    try {
      final payload = jsonDecode(action.payloadJson) as Map<String, dynamic>;

      switch (action.actionType) {
        case 'UPSERT_PROFILE':
          await _sb
              .from('user_health_profiles')
              .upsert(payload, onConflict: 'user_id');
          return _SyncStatus.success;

        case 'LOG_MEAL_RPC':
          // เช็คว่า p_eaten_at มีส่งมาไหม (แก้บั๊กเวลาเพี้ยนข้ามวัน Patch 8)
          final params = {
            'p_food_id': payload['food_id'],
            'p_food_name': payload['food_name'],
            'p_quantity_g': payload['quantity_g'],
            'p_meal_type': payload['meal_type'],
            'p_protein': payload['protein'],
            'p_potassium': payload['potassium'],
            'p_sodium': payload['sodium'],
            'p_sugar': payload['sugar'],
            'p_carb': payload['carb'],
            'p_water': payload['water'],
            'p_eaten_at': payload['eaten_at'], // ส่งเวลาที่กินจริงไป
          };
          await _sb.rpc('log_meal', params: params);
          return _SyncStatus.success;

        case 'DELETE_MEAL_RPC':
          await _sb.rpc(
            'delete_meal',
            params: {'p_meal_id': payload['meal_id']},
          );
          return _SyncStatus.success;

        case 'ADD_CUSTOM_FOOD':
          final user = _sb.auth.currentUser;
          if (user != null) {
            payload['user_id'] = user.id;
            await _sb.from('custom_foods').insert(payload);
          }
          return _SyncStatus.success;

        default:
          debugPrint('Unknown Action Type: ${action.actionType}');
          return _SyncStatus.permanentError; // ไม่รู้จัก Type นี้
      }
    } on PostgrestException catch (e) {
      debugPrint('Supabase Database Error: $e');
      return _SyncStatus.permanentError;
    } catch (e) {
      debugPrint('Network or Temporary Error: $e');
      return _SyncStatus.temporaryError;
    }
  }
}

enum _SyncStatus { success, temporaryError, permanentError }
