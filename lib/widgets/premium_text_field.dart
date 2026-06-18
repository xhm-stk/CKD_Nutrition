import 'package:flutter/material.dart';

class PremiumTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool isPassword;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const PremiumTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.prefixIcon,
    this.hint,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onChanged,
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
    Color borderColor = Colors.transparent;
    if (hasError) {
      borderColor = theme.colorScheme.error;
    } else if (_isFocused) {
      borderColor = theme.colorScheme.primary;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF131B2B), // bgSurface
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: _isFocused || hasError ? 1.5 : 1.0,
            ),
            boxShadow:
                _isFocused && !hasError
                    ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ]
                    : [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hint,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              prefixIcon: Icon(
                widget.prefixIcon,
                color:
                    _isFocused
                        ? theme.colorScheme.primary
                        : Colors.white.withValues(alpha: 0.4),
              ),
              suffixIcon:
                  widget.isPassword
                      ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.white.withValues(alpha: 0.4),
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
