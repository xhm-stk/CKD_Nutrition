import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:isar/isar.dart';
import 'package:ckd_nutrition_app/pages/food/food_search_page.dart';
import 'package:ckd_nutrition_app/repositories/food_repository.dart';
import 'package:ckd_nutrition_app/controllers/meal_controller.dart';
import 'package:ckd_nutrition_app/providers/core_providers.dart';
import 'package:ckd_nutrition_app/providers/meal_providers.dart';
import 'package:ckd_nutrition_app/models/isar/food_item.dart';

class MockIsar extends Mock implements Isar {}

class MockFoodRepository extends Mock implements FoodRepository {}

class MockMealController extends Mock implements MealController {}

void main() {
  group('FoodSearchPage Widget Tests', () {
    late MockFoodRepository mockFoodRepo;
    late MockMealController mockMealCtrl;

    setUp(() {
      mockFoodRepo = MockFoodRepository();
      mockMealCtrl = MockMealController();
    });

    Widget createWidgetUnderTest() {
      return ProviderScope(
        overrides: [
          foodRepositoryProvider.overrideWithValue(mockFoodRepo),
          mealControllerProvider.overrideWithValue(mockMealCtrl),
        ],
        child: const MaterialApp(home: FoodSearchPage()),
      );
    }

    testWidgets('Shows no results message when empty', (
      WidgetTester tester,
    ) async {
      when(() => mockFoodRepo.searchFood(any())).thenAnswer((_) async => []);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('ไม่พบรายการอาหาร'), findsOneWidget);
    });

    testWidgets('Shows food items and opens BottomSheet on tap', (
      WidgetTester tester,
    ) async {
      final food1 =
          FoodItem()
            ..foodId = 'F1'
            ..name = 'Apple'
            ..proteinG = 0.5
            ..sodiumMg = 1.0
            ..servingSize = '100g';

      when(
        () => mockFoodRepo.searchFood(any()),
      ).thenAnswer((_) async => [food1]);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('โปรตีน: 0.5g | โซเดียม: 1.0mg'), findsOneWidget);

      // Tap to open bottom sheet
      await tester.tap(find.text('Apple'));
      await tester.pumpAndSettle();

      expect(find.text('บันทึก Apple'), findsOneWidget);
      expect(find.text('บันทึกมื้อนี้'), findsOneWidget);
    });
  });
}
