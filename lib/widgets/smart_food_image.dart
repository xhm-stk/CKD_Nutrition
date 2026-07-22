import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class SmartFoodImage extends StatefulWidget {
  final String foodId;
  final String foodName;
  final double width;
  final double height;
  final double borderRadius;

  const SmartFoodImage({
    super.key,
    required this.foodId,
    required this.foodName,
    this.width = 56,
    this.height = 56,
    this.borderRadius = 12,
  });

  @override
  State<SmartFoodImage> createState() => _SmartFoodImageState();
}

class _SmartFoodImageState extends State<SmartFoodImage> {
  String? _customImagePath;

  @override
  void initState() {
    super.initState();
    _loadCustomImage();
  }

  @override
  void didUpdateWidget(covariant SmartFoodImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.foodName != widget.foodName || oldWidget.foodId != widget.foodId) {
      _loadCustomImage();
    }
  }

  Future<void> _loadCustomImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final path = prefs.getString('custom_food_img_${widget.foodName}');
      if (path != null && File(path).existsSync()) {
        if (mounted) {
          setState(() {
            _customImagePath = path;
          });
        }
      } else if (_customImagePath != null) {
        if (mounted) {
          setState(() {
            _customImagePath = null;
          });
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: AppTheme.brandPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: _buildImageContent(),
      ),
    );
  }

  Widget _buildImageContent() {
    if (_customImagePath != null) {
      return Image.file(
        File(_customImagePath!),
        fit: BoxFit.cover,
        width: widget.width,
        height: widget.height,
        errorBuilder: (ctx, err, stack) => _buildPlaceholder(),
      );
    }

    final trimmedId = widget.foodId.trim();
    if (trimmedId.isEmpty || trimmedId.startsWith('custom_')) {
      return _buildPlaceholder();
    }

    return Image.asset(
      'assets/food_images/$trimmedId.webp',
      fit: BoxFit.cover,
      width: widget.width,
      height: widget.height,
      errorBuilder: (ctx, err, stack) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Icon(
      Icons.restaurant_menu_rounded,
      color: AppTheme.brandPrimary.withValues(alpha: 0.7),
      size: widget.width * 0.5,
    );
  }
}
