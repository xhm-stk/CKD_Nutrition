import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomTimeDatePicker {
  /// แสดง TimePicker รูปแบบ 24 ชั่วโมง โดยไม่มีวงปฏิทินนาฬิกา
  /// สามารถกดปุ่มเพิ่ม (+1) หรือลด (-1) ชั่วโมงและนาทีได้อย่างสะดวก
  static Future<TimeOfDay?> show24hTimePicker({
    required BuildContext context,
    required TimeOfDay initialTime,
    TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
  }) async {
    return await showDialog<TimeOfDay>(
      context: context,
      builder:
          (context) => _CustomStepperTimePickerDialog(initialTime: initialTime),
    );
  }

  /// แสดง DatePicker (ปฏิทิน) แบบพรีเมียม สวยงาม
  static Future<DateTime?> showCustomDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                isDark
                    ? const ColorScheme.dark(
                      primary: AppTheme.brandPrimary,
                      onPrimary: Colors.white,
                      surface: AppTheme.bgSurface,
                      onSurface: Colors.white,
                    )
                    : const ColorScheme.light(
                      primary: AppTheme.brandPrimary,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Color(0xFF0F172A),
                    ),
            dialogTheme: DialogTheme(
              backgroundColor: isDark ? AppTheme.bgSurface : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 6,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: isDark ? AppTheme.bgSurface : Colors.white,
              headerBackgroundColor: AppTheme.brandPrimary,
              headerForegroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              dayStyle: const TextStyle(fontWeight: FontWeight.w600),
              todayBorder: const BorderSide(
                color: AppTheme.brandPrimary,
                width: 1.5,
              ),
              todayBackgroundColor: WidgetStateProperty.all(
                AppTheme.brandPrimary.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

class _CustomStepperTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;

  const _CustomStepperTimePickerDialog({required this.initialTime});

  @override
  State<_CustomStepperTimePickerDialog> createState() =>
      __CustomStepperTimePickerDialogState();
}

class __CustomStepperTimePickerDialogState
    extends State<_CustomStepperTimePickerDialog> {
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialTime.hour;
    _minute = widget.initialTime.minute;
  }

  void _incrementHour() {
    setState(() {
      _hour = (_hour + 1) % 24;
    });
  }

  void _decrementHour() {
    setState(() {
      _hour = (_hour - 1 + 24) % 24;
    });
  }

  void _incrementMinute() {
    setState(() {
      _minute = (_minute + 1) % 60;
    });
  }

  void _decrementMinute() {
    setState(() {
      _minute = (_minute - 1 + 60) % 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppTheme.bgSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'เลือกเวลา (24 ชั่วโมง)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hour Stepper
                _buildStepperColumn(
                  context: context,
                  label: 'ชั่วโมง',
                  valueStr: _hour.toString().padLeft(2, '0'),
                  onIncrement: _incrementHour,
                  onDecrement: _decrementHour,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandPrimary,
                    ),
                  ),
                ),
                // Minute Stepper
                _buildStepperColumn(
                  context: context,
                  label: 'นาที',
                  valueStr: _minute.toString().padLeft(2, '0'),
                  onIncrement: _incrementMinute,
                  onDecrement: _decrementMinute,
                ),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(
                        color: AppTheme.brandPrimary.withValues(alpha: 0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        () => Navigator.of(
                          context,
                        ).pop(TimeOfDay(hour: _hour, minute: _minute)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.brandPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'บันทึก',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperColumn({
    required BuildContext context,
    required String label,
    required String valueStr,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onIncrement,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.brandPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.keyboard_arrow_up_rounded,
              color: AppTheme.brandPrimary,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 76,
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppTheme.brandPrimary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.brandPrimary.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Text(
            valueStr,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.brandPrimary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onDecrement,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.brandPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.brandPrimary,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
