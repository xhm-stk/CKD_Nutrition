import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../providers/core_providers.dart';

class NetworkOverlay extends ConsumerWidget {
  final Widget child;

  const NetworkOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityProvider);
    final isOfflineMode = ref.watch(offlineModeProvider);
    final supabase = ref.watch(supabaseProvider);

    return connectivityAsync.when(
      data: (results) {
        final isOffline = results.contains(ConnectivityResult.none) || results.isEmpty;
        
        // ถ้าออนไลน์, ผู้ใช้กดเข้าสู่โหมดออฟไลน์แล้ว, หรือยังไม่ได้ล็อกอิน ให้แสดงแอปปกติ
        if (!isOffline || isOfflineMode || supabase.auth.currentUser == null) {
          return child;
        }

        return Stack(
          children: [
            child, // พื้นหลังคือแอปเดิม
            // ตัวบล็อกหน้าจอ
            Container(
              color: Colors.black.withValues(alpha: 0.8), // จำลองสีพื้นหลังตอนขึ้น Dialog
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.wifi_off_rounded,
                            size: 60,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'ไม่มีการเชื่อมต่ออินเทอร์เน็ต',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'กรุณาตรวจสอบอินเทอร์เน็ตของคุณ\nหากต้องการดูข้อมูลเดิมสามารถเข้าสู่โหมดออฟไลน์ได้',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton(
                              onPressed: () {
                                // กดแล้วระบบจะประเมิน stream connectivity ใหม่อัตโนมัติถาวร
                                // ใส่เพื่อให้ผู้ใช้รู้สึกได้กด
                              },
                              child: const Text('ลองอีกครั้ง'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                // ปลดล็อกเข้าโหมดออฟไลน์
                                ref.read(offlineModeProvider.notifier).state = true;
                              },
                              child: const Text('ทำงานแบบออฟไลน์'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => Stack(
        children: [
          child,
          const Center(child: CircularProgressIndicator()),
        ],
      ),
      error: (e, st) => child,
    );
  }
}

