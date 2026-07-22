import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/isar/food_item.dart';
import '../../providers/core_providers.dart';
import '../../providers/meal_providers.dart';
import '../../controllers/food_search_controller.dart';
import '../../core/result.dart';
import 'package:ckd_nutrition_app/l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mesh_gradient_background.dart';
import '../../widgets/smart_food_image.dart';

class FoodSearchPage extends ConsumerStatefulWidget {
  const FoodSearchPage({super.key});

  @override
  ConsumerState<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends ConsumerState<FoodSearchPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _selectedCategory = 'ทั้งหมด';
  final List<String> _categories = [
    'ทั้งหมด',
    'กับข้าว',
    'อาหารจานเดียว/เส้น',
    'ผลไม้',
    'เครื่องดื่ม',
    'ผัก',
    'เนื้อสัตว์',
    'เครื่องปรุง',
  ];

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showLogDialog(FoodItem food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) => _FoodLogBottomSheet(food: food),
    );
  }

  Widget _buildNutrientTag(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 0.8),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(foodSearchControllerProvider);
    final filteredResults =
        _selectedCategory == 'ทั้งหมด'
            ? searchState.results
            : searchState.results
                .where((f) => f.category == _selectedCategory)
                .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: SizedBox(
            height: 42,
            child: TextField(
              key: const Key('input_search_food'),
              controller: _searchCtrl,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchFoodHint,
                filled: true,
                fillColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.white,
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 11,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: AppTheme.brandPrimary.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: AppTheme.brandPrimary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: AppTheme.brandPrimary,
                    width: 1.5,
                  ),
                ),
                suffixIcon:
                    _searchCtrl.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.7),
                            size: 18,
                          ),
                          onPressed: () {
                            _searchCtrl.clear();
                            ref
                                .read(foodSearchControllerProvider.notifier)
                                .search('');
                          },
                        )
                        : null,
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
              ),
              cursorColor: AppTheme.brandPrimary,
              onChanged: (val) {
                ref.read(foodSearchControllerProvider.notifier).search(val);
              },
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: MeshGradientBackground(
        child: Column(
          children: [
            // Horizontal scrolling category chips
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      showCheckmark: false,
                      label: Text(
                        category,
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.8),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppTheme.brandPrimary,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? Colors.transparent
                                  : Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.1),
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            // Results list or states
            Expanded(
              child:
                  searchState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredResults.isEmpty
                      ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.noFoodFound,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 16,
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: filteredResults.length,
                        itemBuilder: (ctx, i) {
                          final f = filteredResults[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            color: AppTheme.getElevated(context),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _showLogDialog(f),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SmartFoodImage(
                                      foodId: f.foodId,
                                      foodName: f.name,
                                      width: 64,
                                      height: 64,
                                      borderRadius: 12,
                                    ),
                                    const SizedBox(width: 16),

                                    // Middle section: name & 6 nutrients
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            f.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          // 6 Nutrients wrap (including water)
                                          Wrap(
                                            spacing: 5,
                                            runSpacing: 5,
                                            children: [
                                              _buildNutrientTag(
                                                context,
                                                AppLocalizations.of(
                                                  context,
                                                )!.protein,
                                                '${f.proteinG.toStringAsFixed(1)}g',
                                                const Color(0xFF34D399),
                                              ),
                                              _buildNutrientTag(
                                                context,
                                                AppLocalizations.of(
                                                  context,
                                                )!.carbs,
                                                '${f.carbG.toStringAsFixed(1)}g',
                                                const Color(0xFFFBBF24),
                                              ),
                                              _buildNutrientTag(
                                                context,
                                                AppLocalizations.of(
                                                  context,
                                                )!.sugar,
                                                '${f.sugarG.toStringAsFixed(1)}g',
                                                AppTheme.brandSecondary,
                                              ),
                                              _buildNutrientTag(
                                                context,
                                                AppLocalizations.of(
                                                  context,
                                                )!.sodium,
                                                '${f.sodiumMg.toStringAsFixed(0)}mg',
                                                const Color(0xFF38BDF8),
                                              ),
                                              _buildNutrientTag(
                                                context,
                                                AppLocalizations.of(
                                                  context,
                                                )!.potassium,
                                                '${f.potassiumMg.toStringAsFixed(0)}mg',
                                                const Color(0xFFF87171),
                                              ),
                                              _buildNutrientTag(
                                                context,
                                                AppLocalizations.of(
                                                  context,
                                                )!.water,
                                                '${f.waterMl.toStringAsFixed(0)}ml',
                                                const Color(0xFF60A5FA),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Right section: Circular '+' button
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: AppTheme.brandPrimary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodLogBottomSheet extends ConsumerStatefulWidget {
  final FoodItem food;
  const _FoodLogBottomSheet({required this.food});

  @override
  ConsumerState<_FoodLogBottomSheet> createState() =>
      _FoodLogBottomSheetState();
}

class _FoodLogBottomSheetState extends ConsumerState<_FoodLogBottomSheet> {
  final _ctrl = TextEditingController(text: '1');
  String _type = 'lunch';
  bool _isSubmitting = false;
  TimeOfDay _eatenTime = TimeOfDay.now();

  @override
  void dispose() {
    _ctrl.dispose(); // แก้ Memory Leak
    super.dispose();
  }

  void _submit() async {
    double multiplier = double.tryParse(_ctrl.text) ?? 0.0;

    // แก้ Data Integrity: Input Validation
    if (multiplier <= 0 || multiplier > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.invalidQuantity),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    double baseWeight = 100.0;
    final match = RegExp(r'(\d+)').firstMatch(widget.food.servingSize);
    if (match != null) baseWeight = double.parse(match.group(0)!);

    double totalGrams = multiplier * baseWeight;

    final now = DateTime.now();
    final eatenAt = DateTime(
      now.year,
      now.month,
      now.day,
      _eatenTime.hour,
      _eatenTime.minute,
    );

    final result = await ref
        .read(mealControllerProvider)
        .logMeal(
          food: widget.food,
          quantityG: totalGrams,
          mealType: _type,
          eatenAt: eatenAt,
        );

    // แก้ Route Popping Vulnerability
    if (!mounted) return;
    Navigator.pop(context); // ปิด BottomSheet อย่างปลอดภัย

    if (result is Success) {
      if (!mounted) return;
      ref.invalidate(dashboardSummaryProvider);
      ref.invalidate(todayMealsProvider);
      Navigator.pop(context); // กลับไปหน้า Dashboard
    } else if (result is Failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.userMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: Stack(
        children: [
          // Background layer with Mesh Gradient
          Positioned.fill(
            child: Stack(
              children: [
                Container(color: Theme.of(context).scaffoldBackgroundColor),
                Positioned(
                  top: -80,
                  left: -80,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.brandPrimary.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -100,
                  right: -60,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.brandAccent.withValues(alpha: 0.10),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),

          // Foreground Content
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle line
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Row(
                  children: [
                    SmartFoodImage(
                      foodId: widget.food.foodId,
                      foodName: widget.food.name,
                      width: 44,
                      height: 44,
                      borderRadius: 10,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'บันทึก ${widget.food.name}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  key: const Key('input_portion'),
                  controller: _ctrl,
                  decoration: InputDecoration(
                    labelText: 'จำนวน',
                    labelStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    suffixText: 'หน่วย (1 หน่วย = ${widget.food.servingSize})',
                    suffixStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.black.withValues(alpha: 0.08),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.brandPrimary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  cursorColor: AppTheme.brandPrimary,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  key: const Key('dropdown_meal_type'),
                  value: _type,
                  dropdownColor: AppTheme.getElevated(context),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.meal,
                    labelStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.getBorderColor(context),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.brandPrimary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'breakfast',
                      child: Text(
                        AppLocalizations.of(context)!.breakfast,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'lunch',
                      child: Text(
                        AppLocalizations.of(context)!.lunch,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'dinner',
                      child: Text(
                        AppLocalizations.of(context)!.dinner,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'snack',
                      child: Text(
                        'ของว่าง',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (val) => setState(() => _type = val!),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'เวลาที่รับประทาน',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _eatenTime,
                          initialEntryMode: TimePickerEntryMode.input,
                          builder:
                              (context, child) => Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppTheme.brandPrimary,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: Color(0xFF0F172A),
                                  ),
                                  dialogTheme: const DialogTheme(
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                child: child!,
                              ),
                        );
                        if (picked != null) {
                          setState(() => _eatenTime = picked);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.getBorderColor(context),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${_eatenTime.hour.toString().padLeft(2, '0')}:${_eatenTime.minute.toString().padLeft(2, '0')} น.',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.access_time_rounded,
                              color: AppTheme.brandPrimary,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _isSubmitting
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(
                                color: Colors.black.withValues(alpha: 0.08),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            key: const Key('btn_confirm_eat'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: AppTheme.brandPrimary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                            ),
                            onPressed: _submit,
                            child: Text(
                              AppLocalizations.of(context)!.saveThisMeal,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
