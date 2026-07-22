import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PremiumDropdownField<T> extends StatefulWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final IconData? prefixIcon;

  final bool isCompact;
  final bool enabled;

  const PremiumDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
    this.isCompact = false,
    this.enabled = true,
  });

  @override
  State<PremiumDropdownField<T>> createState() => _PremiumDropdownFieldState();
}

class _PremiumDropdownFieldState<T> extends State<PremiumDropdownField<T>> {
  bool _isFocused = false;

  void _showBottomSheet() {
    setState(() => _isFocused = true);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Indicator
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),

              // Title / Label
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),

              // Selection Options
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children:
                      widget.items.map((item) {
                        final isSelected = item.value == widget.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Material(
                            color:
                                isSelected
                                    ? AppTheme.brandPrimary.withValues(
                                      alpha: 0.06,
                                    )
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              onTap: () {
                                widget.onChanged(item.value);
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? AppTheme.brandPrimary.withValues(
                                              alpha: 0.4,
                                            )
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.08),
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: DefaultTextStyle(
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                          color:
                                              isSelected
                                                  ? AppTheme.brandPrimary
                                                  : Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                        ),
                                        child: item.child,
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: AppTheme.brandPrimary,
                                        size: 22,
                                      )
                                    else
                                      Icon(
                                        Icons.circle_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.2),
                                        size: 22,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    ).whenComplete(() {
      if (mounted) {
        setState(() => _isFocused = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.white.withValues(alpha: 0.08);
    final theme = Theme.of(context);
    if (!widget.enabled) {
      borderColor = theme.colorScheme.onSurface.withValues(alpha: 0.05);
    } else if (_isFocused) {
      borderColor = AppTheme.brandPrimary;
    }

    final selectedItem = widget.items.firstWhere(
      (item) => item.value == widget.value,
      orElse: () => widget.items.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              width: _isFocused ? 1.5 : 1.0,
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
            child: InkWell(
              onTap: widget.enabled ? _showBottomSheet : null,
              borderRadius: BorderRadius.circular(30.0),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: widget.isCompact ? 12 : 18,
                ),
                child: Row(
                  children: [
                    if (widget.prefixIcon != null) ...[
                      Icon(
                        widget.prefixIcon,
                        color:
                            _isFocused
                                ? AppTheme.brandPrimary
                                : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: widget.isCompact ? 14 : 16,
                        ),
                        child: selectedItem.child,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.4),
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
