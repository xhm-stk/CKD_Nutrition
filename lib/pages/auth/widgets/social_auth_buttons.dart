import 'package:flutter/material.dart';
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
          child: OutlinedButton.icon(
            onPressed: () async {
              final error =
                  await ref.read(authControllerProvider).signInWithGoogle();
              if (error != null) {
                if (!context.mounted) return;
                _handleError(context, error);
              }
            },
            icon: const Icon(Icons.g_mobiledata, color: Colors.red, size: 24),
            label: const Text('Google', style: TextStyle(color: Colors.black)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        if (Platform.isIOS) ...[
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () async {
                final error =
                    await ref.read(authControllerProvider).signInWithApple();
                if (error != null) {
                  if (!context.mounted) return;
                  _handleError(context, error);
                }
              },
              icon: const Icon(Icons.apple, color: Colors.black, size: 20),
              label: const Text('Apple', style: TextStyle(color: Colors.black)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
