import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/meal_providers.dart';

class MealPlannerPage extends ConsumerWidget {
  const MealPlannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plannerAsync = ref.watch(mealPlannerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🧠 AI แนะนำอาหาร 3 มื้อ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'สุ่มใหม่ (Refresh)',
            onPressed: () {
              ref.invalidate(mealPlannerProvider);
            },
          ),
        ],
      ),
      body: plannerAsync.when(
        data: (meals) {
          if (meals.isEmpty) {
            return const Center(
              child: Text('ไม่สามารถหาเมนูที่พอดีกับโควต้าได้'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final m = meals[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.restaurant)),
                  title: Text(
                    m['name'] ?? 'ไม่มีชื่อ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'โปรตีน: ${m['protein_g']}g | โซเดียม: ${m['sodium_mg']}mg\nคาร์บ: ${m['carb_g']}g | โพแทสเซียม: ${m['potassium_mg']}mg',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
        loading:
            () => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('กำลังคำนวณอาหารที่เหมาะสม...'),
                ],
              ),
            ),
        error: (err, st) => Center(child: Text('เกิดข้อผิดพลาด: $err')),
      ),
    );
  }
}
