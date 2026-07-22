import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// ช่องกรอกข้อความพรีเมียม — Emerald Focus Bloom Edition
/// รองรับ: Focus Glow สีเขียว, ความมน 24px, Error state
class PremiumTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool isPassword;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)?
  validator; // เพิ่ม validator เพื่อรองรับ Form

  final bool isCompact;
  final bool enabled;

  const PremiumTextField({
    super.key,
    required this.label,
    required this.controller,
    this.prefixIcon,
    this.hint,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onChanged,
    this.validator,
    this.isCompact = false,
    this.enabled = true,
  });

  @override
  State<PremiumTextField> createState() => _PremiumTextFieldState();
}

class _PremiumTextFieldState extends State<PremiumTextField> {
  bool _obscureText = true;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    // สีขอบ (Border Color)
    Color borderColor = Colors.white.withValues(alpha: 0.08);
    if (!widget.enabled) {
      borderColor = theme.colorScheme.onSurface.withValues(alpha: 0.05);
    } else if (hasError) {
      borderColor = theme.colorScheme.error;
    } else if (_isFocused) {
      borderColor = AppTheme.brandPrimary;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Floating Label
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 13,
            fontWeight: _isFocused ? FontWeight.w500 : FontWeight.w300,
            color:
                _isFocused
                    ? AppTheme.brandPrimary
                    : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          child: Text(widget.label),
        ),
        SizedBox(height: widget.isCompact ? 4 : 8),

        // Text Field Container with Focus Bloom
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: widget.enabled
                ? AppTheme.getSurface(context)
                : AppTheme.getSurface(context).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              color: borderColor,
              width: _isFocused || hasError ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isFocused
                    ? AppTheme.brandPrimary.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: widget.enabled ? 0.04 : 0.01),
                blurRadius: _isFocused ? 16 : 8,
                spreadRadius: _isFocused ? 2 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: _obscureText,
              keyboardType: widget.keyboardType,
              enabled: widget.enabled,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: widget.isCompact ? 14 : 16,
              ),
              onChanged: widget.onChanged,
              validator: widget.validator,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.3),
                  fontSize: widget.isCompact ? 14 : 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: widget.isCompact ? 12 : 18,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          widget.prefixIcon,
                          key: ValueKey(_isFocused),
                          color:
                              _isFocused
                                  ? AppTheme.brandPrimary
                                  : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      )
                    : null,
                suffixIcon:
                    widget.isPassword
                        ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                        : null,
              ),
            ),
          ),
        ),

        // Error message
        if (hasError) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              widget.errorText!,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}
