import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/dashboard/widgets/add_action_sheet.dart';

class MainScaffold extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // ปรับโครงสร้างเพื่อรองรับปุ่มใหญ่ตรงกลาง
    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddActionSheet.show(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.teal.shade700,
          unselectedItemColor: Colors.grey.shade400,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            // เนื่องจากเรามีปุ่ม FAB ตรงกลาง ทำให้เราต้องคำนวณ Index ข้าม
            // แท็บมี 4 อัน: 0(Dashboard), 1(Diary), 2(Food), 3(Account)
            _goBranch(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'แดชบอร์ด',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded),
              label: 'ไดอารี่',
            ),
            // ช่องว่างตรงกลางสำหรับ FAB
            // BottomNavigationBarItem(icon: Icon(Icons.clear, color: Colors.transparent), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'รายการอาหาร',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'บัญชี',
            ),
          ],
        ),
      ),
    );
  }
}
