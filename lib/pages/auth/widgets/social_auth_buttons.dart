import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io' show Platform;
import '../../../controllers/auth_controller.dart';

class SocialAuthButtons extends ConsumerWidget {
  const SocialAuthButtons({super.key});

  void _handleError(BuildContext context, String error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _GlassSocialButton(
            icon: Icons.g_mobiledata,
            label: 'Google',
            color: Colors.white,
            onPressed: () async {
              final error =
                  await ref.read(authControllerProvider).signInWithGoogle();
              if (error != null) {
                if (!context.mounted) return;
                _handleError(context, error);
              }
            },
          ),
        ),
        if (Platform.isIOS) ...[
          const SizedBox(width: 16),
          Expanded(
            child: _GlassSocialButton(
              icon: Icons.apple,
              label: 'Apple',
              color: Colors.white,
              onPressed: () async {
                final error =
                    await ref.read(authControllerProvider).signInWithApple();
                if (error != null) {
                  if (!context.mounted) return;
                  _handleError(context, error);
                }
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _GlassSocialButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _GlassSocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  State<_GlassSocialButton> createState() => _GlassSocialButtonState();
}

class _GlassSocialButtonState extends State<_GlassSocialButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: 56,
        decoration: BoxDecoration(
          color:
              _isPressed
                  ? const Color(0xFF1F293B) // Slightly lighter on press
                  : const Color(0xFF151C2C), // bgSurface
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: _isPressed ? 0.2 : 0.08),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: widget.color, size: 28),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
