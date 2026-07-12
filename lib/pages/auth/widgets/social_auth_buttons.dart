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
            color: const Color(0xFFEA4335), // Google Red
            isBeta: true,
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
              color:
                  Theme.of(
                    context,
                  ).colorScheme.onSurface, // Visible Apple color
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
  final bool isBeta;

  const _GlassSocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.isBeta = false,
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
                  ? const Color(0xFFE0F2FE) // Sky 100 on press
                  : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black.withValues(alpha: _isPressed ? 0.12 : 0.06),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: widget.color, size: 28),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.isBeta) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                child: const Text(
                  'BETA',
                  style: TextStyle(
                    color: Color(0xFFD97706),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
