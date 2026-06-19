import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/dashboard/widgets/add_action_sheet.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/core_providers.dart';
import 'package:table_calendar/table_calendar.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // เพื่อให้สามารถกดแท็บเดิมเพื่อย้อนกลับไปหน้าแรกของแท็บนั้นได้ (Pop to root)
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ปรับโครงสร้างเพื่อรองรับปุ่มใหญ่ตรงกลาง
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomAppBar(
        elevation: 0, // ลบเงา
        color: Theme.of(context).scaffoldBackgroundColor, // สีเดียวกับพื้นหลัง
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              icon: Icons.home_rounded,
              label: 'แดชบอร์ด',
              index: 0,
            ),

            // ปุ่มบวกตรงกลาง (อยู่ระดับเดียวกับเมนูอื่นๆ)
            InkWell(
              onTap: () {
                final selectedDate = ref.read(selectedDateProvider);
                if (!isSameDay(selectedDate, DateTime.now())) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'คุณสามารถบันทึกอาหารได้เฉพาะวันที่ปัจจุบันเท่านั้น',
                      ),
                    ),
                  );
                  return;
                }
                AddActionSheet.show(context);
              },
              customBorder: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.primary, // สีเดียวกับธีมแอป
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),

            _buildNavItem(
              context,
              icon: Icons.person_rounded,
              label: 'บัญชี',
              index: 1,
            ), // เปลี่ยนจาก index 2 เป็น 1
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = navigationShell.currentIndex == index;
    final color =
        isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.grey.shade500;
    return InkWell(
      onTap: () => _goBranch(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
