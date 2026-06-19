import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PremiumDropdownField<T> extends StatefulWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final IconData prefixIcon;

  const PremiumDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.prefixIcon,
  });

  @override
  State<PremiumDropdownField<T>> createState() => _PremiumDropdownFieldState();
}

class _PremiumDropdownFieldState<T> extends State<PremiumDropdownField<T>> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.white.withValues(alpha: 0.08);
    if (_isFocused) {
      borderColor = AppTheme.brandPrimary;
    }

    return Focus(
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 13,
              fontWeight: _isFocused ? FontWeight.w500 : FontWeight.w300,
              color: _isFocused ? AppTheme.brandPrimary : Colors.white.withValues(alpha: 0.6),
            ),
            child: Text(widget.label),
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: AppTheme.bgSurface,
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: borderColor,
                width: _isFocused ? 1.5 : 1.0,
              ),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: AppTheme.brandPrimary.withValues(alpha: 0.15),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: DropdownButtonFormField<T>(
                value: widget.value,
                items: widget.items,
                borderRadius: BorderRadius.circular(30.0),
                onChanged: (val) {
                  widget.onChanged(val);
                },
                icon: Icon(Icons.arrow_drop_down, color: Colors.white.withValues(alpha: 0.4)),
                dropdownColor: AppTheme.bgElevated,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  prefixIcon: Icon(
                    widget.prefixIcon,
                    color: _isFocused ? AppTheme.brandPrimary : Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
