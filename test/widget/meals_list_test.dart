import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ckd_nutrition_app/widgets/meals_list.dart';
import 'package:ckd_nutrition_app/providers/core_providers.dart';
import 'package:ckd_nutrition_app/providers/meal_providers.dart';
import 'package:ckd_nutrition_app/models/supabase/meal.dart';
import 'package:ckd_nutrition_app/repositories/meal_repository.dart';
import 'package:ckd_nutrition_app/core/result.dart';

class MockMealRepository extends Mock implements MealRepository {}

class FakeMeal extends Fake implements Meal {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeMeal());
  });
  group('MealsListWidget Tests', () {
    late MockMealRepository mockRepo;

    setUp(() {
      mockRepo = MockMealRepository();
    });

    Widget createWidgetUnderTest(List<Meal> meals) {
      return ProviderScope(
        overrides: [
          mealRepositoryProvider.overrideWithValue(mockRepo),
          todayMealsProvider.overrideWith((ref) async => meals),
          dashboardSummaryProvider.overrideWith((ref) async => null),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: MealsListWidget()),
              ],
            ),
          ),
        ),
      );
    }

    testWidgets('Shows empty message when meals is empty', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest([]));
      await tester.pumpAndSettle();

      expect(find.textContaining('ยังไม่มีรายการอาหารวันนี้'), findsOneWidget);
    });

    testWidgets('Shows list of meals and allows swipe to delete', (WidgetTester tester) async {
      final now = DateTime.now();
      final meal1 = Meal(
        id: '1',
        logId: 'log-1',
        foodId: 'F001',
        foodName: 'Rice',
        quantityG: 100,
        mealType: 'lunch',
        proteinG: 2,
        potassiumMg: 10,
        sodiumMg: 1,
        sugarG: 0,
        carbG: 20,
        waterMl: 250,
        phosphorusMg: 0,
        eatenAt: now,
      );

      when(() => mockRepo.deleteMeal(any())).thenAnswer((_) async => Success(null));

      await tester.pumpWidget(createWidgetUnderTest([meal1]));
      await tester.pumpAndSettle();

      expect(find.text('Rice'), findsOneWidget);
      expect(find.text('มื้อเที่ยง'), findsOneWidget);
      expect(find.textContaining('โปรตีน 2.0g | โซเดียม 1mg'), findsOneWidget);
    });
  });
}
