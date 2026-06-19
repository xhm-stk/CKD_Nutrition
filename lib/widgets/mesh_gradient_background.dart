import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Widget ฉากหลังเรืองแสงสีเขียวมรกต (Emerald Mesh Gradient)
/// ใช้ร่วมกันในหน้า Login, Register และ Dashboard
/// ห่อด้วย RepaintBoundary เพื่อป้องกัน GPU re-render ซ้ำ
class MeshGradientBackground extends StatelessWidget {
  final Widget child;

  const MeshGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base color layer
        Container(color: AppTheme.bgBase),

        // Mesh gradient orbs — cached by RepaintBoundary (1 layer only)
        RepaintBoundary(
          child: Stack(
            children: [
              // Emerald orb (top-left)
              Positioned(
                top: -80,
                left: -80,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.brandPrimary.withValues(alpha: 0.15),
                  ),
                ),
              ),
              // Mint orb (bottom-right)
              Positioned(
                bottom: -100,
                right: -60,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.brandAccent.withValues(alpha: 0.10),
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
