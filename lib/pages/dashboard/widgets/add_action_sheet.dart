import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddActionSheet extends StatelessWidget {
  const AddActionSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddActionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B), // bgElevated
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ขีดตรงกลางด้านบน (Drag Handle)
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'เพิ่มมื้ออาหารของคุณ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'เลือกวิธีเพิ่มอาหารที่คุณทานในวันนี้',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // ปุ่มตัวเลือกต่างๆ
            _buildActionItem(
              context,
              icon: Icons.qr_code_scanner_rounded,
              title: 'สแกนบาร์โค้ด',
              subtitle: 'ค้นหาจากฐานข้อมูลสินค้าสำเร็จรูป',
              color: Colors.teal,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ฟีเจอร์สแกนบาร์โค้ดกำลังพัฒนา'),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildActionItem(
              context,
              icon: Icons.restaurant_menu_rounded,
              title: 'เพิ่มเมนูจากแอป',
              subtitle: 'เลือกจากรายการอาหารสุขภาพในแอป',
              color: Colors.orange,
              onTap: () {
                Navigator.pop(context);
                // อาจจะลิงก์ไปหน้า Food Tab
                context.go('/food');
              },
            ),
            const SizedBox(height: 16),
            _buildActionItem(
              context,
              icon: Icons.camera_alt_rounded,
              title: 'วิเคราะห์จากรูปภาพ',
              subtitle: 'ใช้ AI ช่วยประเมินสารอาหารจากภาพถ่าย',
              color: Colors.purple,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ฟีเจอร์ AI วิเคราะห์ภาพกำลังพัฒนา'),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildActionItem(
              context,
              icon: Icons.edit_note_rounded,
              title: 'กำหนดเมนูอาหารทำเอง',
              subtitle: 'กรอกข้อมูลโภชนาการด้วยตัวเอง',
              color: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                context.push('/food-add');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
