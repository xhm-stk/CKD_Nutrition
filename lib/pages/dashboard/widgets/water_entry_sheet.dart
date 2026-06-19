import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WaterEntrySheet extends ConsumerStatefulWidget {
  final Future<void> Function(int ml) onSave;

  const WaterEntrySheet({super.key, required this.onSave});

  @override
  ConsumerState<WaterEntrySheet> createState() => _WaterEntrySheetState();
}

class _WaterEntrySheetState extends ConsumerState<WaterEntrySheet> {
  final TextEditingController _customMlCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit(int ml) async {
    if (ml <= 0) return;
    setState(() => _isLoading = true);
    await widget.onSave(ml);
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _customMlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'บันทึกปริมาณน้ำ',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              )
            ],
          ),
          const SizedBox(height: 16),
          // ปุ่มด่วน
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildQuickButton(100),
              _buildQuickButton(250),
              _buildQuickButton(500),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('หรือระบุเอง (ml)'),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customMlCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'เช่น 150',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        final val = int.tryParse(_customMlCtrl.text.trim()) ?? 0;
                        if (val > 0) {
                          _submit(val);
                        }
                      },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('บันทึก'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(int ml) {
    return ActionChip(
      label: Text('+ $ml ml', style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.blue.shade100,
      labelStyle: TextStyle(color: Colors.blue.shade900),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onPressed: _isLoading ? null : () => _submit(ml),
    );
  }
}
