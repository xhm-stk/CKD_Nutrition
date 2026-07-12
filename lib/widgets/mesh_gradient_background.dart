import 'dart:ui';
import 'package:flutter/material.dart';

/// Widget ฉากหลังเรืองแสงสีเขียวมรกต (Emerald Mesh Gradient)
/// ใช้ร่วมกันในหน้า Login, Register และ Dashboard
/// ห่อด้วย RepaintBoundary เพื่อป้องกัน GPU re-render ซ้ำ
class MeshGradientBackground extends StatelessWidget {
  final Widget child;

  const MeshGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseBgColor = theme.scaffoldBackgroundColor;
    final primaryColor = theme.colorScheme.primary;
    final accentColor =
        isDark ? const Color(0xFF00B4D8) : const Color(0xFF38BDF8);

    return Stack(
      children: [
        // Base color layer
        Container(color: baseBgColor),

        // Mesh gradient orbs — cached by RepaintBoundary
        RepaintBoundary(
          child: Stack(
            children: [
              // Primary orb (top-left)
              Positioned(
                top: -80,
                left: -80,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withValues(alpha: isDark ? 0.15 : 0.08),
                  ),
                ),
              ),
              // Accent orb (bottom-right)
              Positioned(
                bottom: -100,
                right: -60,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor.withValues(alpha: isDark ? 0.10 : 0.08),
                  ),
                ),
              ),
              // Heavy blur to merge orbs into a soft ambient light
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ],
          ),
        ),

        // Foreground content
        Positioned.fill(child: child),
      ],
    );
  }
}
