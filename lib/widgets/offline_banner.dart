import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final results = snapshot.data!;
        final isOffline =
            results.every((r) => r == ConnectivityResult.none) ||
            results.isEmpty;

        if (!isOffline) return const SizedBox.shrink();

        return Container(
          color: Colors.amber.shade800,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'คุณกำลังอยู่ในโหมดออฟไลน์ ข้อมูลจะถูกซิงก์ภายหลัง',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
