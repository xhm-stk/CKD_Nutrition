import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/core_providers.dart';
import '../repositories/meal_repository.dart';
import '../core/result.dart';

class MealsListWidget extends ConsumerStatefulWidget {
  const MealsListWidget({super.key});

  @override
  ConsumerState<MealsListWidget> createState() => _MealsListWidgetState();
}

class _MealsListWidgetState extends ConsumerState<MealsListWidget> {
  final Set<String> _optimisticDeletedIds = {};

  @override
  Widget build(BuildContext context) {
    final mealsAsync = ref.watch(todayMealsProvider);

    return mealsAsync.when(
      data: (rawMeals) {
        final meals = rawMeals.where((m) => !_optimisticDeletedIds.contains(m.id)).toList();

        if (meals.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(
              child: Text(
                'ยังไม่มีรายการอาหารวันนี้\nกดปุ่ม + เพื่อบันทึกมื้อแรกเลย!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return Dismissible(
              key: Key(meal.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.redAccent,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('ลบรายการอาหาร'),
                    content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบเมนู ${meal.foodName}?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('ยกเลิก')),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true), 
                        child: const Text('ลบ', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              onDismissed: (direction) {
                // Optimistically remove from UI to prevent Dismissible assertion error
                setState(() {
                  _optimisticDeletedIds.add(meal.id);
                });

                // Get ScaffoldMessenger before async gap to fix lint warning
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final repo = ref.read(mealRepositoryProvider);
                
                repo.deleteMeal(meal.id).then((res) {
                  if (mounted) {
                    if (res is Success) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text('ลบเมนู ${meal.foodName} แล้ว')),
                      );
                      ref.invalidate(dashboardSummaryProvider);
                      ref.invalidate(todayMealsProvider);
                    } else if (res is Failure) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text(res.userMessage), backgroundColor: Colors.red),
                      );
                      // Revert optimistic delete on failure
                      setState(() {
                        _optimisticDeletedIds.remove(meal.id);
                      });
                    }
                  }
                });
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade50,
                    child: Icon(_getMealIcon(meal.mealType), color: Colors.teal),
                  ),
                  title: Text(meal.foodName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'ปริมาณ: ${meal.quantityG.toStringAsFixed(0)} กรัม\nโปรตีน ${meal.proteinG.toStringAsFixed(1)}g | โซเดียม ${meal.sodiumMg.toStringAsFixed(0)}mg',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  trailing: Text(
                    _getMealTypeName(meal.mealType),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  isThreeLine: true,
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(),
      )),
      error: (e, st) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
    );
  }

  IconData _getMealIcon(String type) {
    switch (type) {
      case 'breakfast': return Icons.wb_twilight;
      case 'lunch': return Icons.wb_sunny;
      case 'dinner': return Icons.nights_stay;
      default: return Icons.local_cafe;
    }
  }

  String _getMealTypeName(String type) {
    switch (type) {
      case 'breakfast': return 'มื้อเช้า';
      case 'lunch': return 'มื้อเที่ยง';
      case 'dinner': return 'มื้อเย็น';
      case 'snack': return 'ของว่าง';
      default: return type;
    }
  }
}
