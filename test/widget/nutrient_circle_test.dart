import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ckd_nutrition_app/widgets/nutrient_circle.dart';

void main() {
  Widget createWidgetUnderTest(double current, double limit) {
    return MaterialApp(
      home: Scaffold(
        body: NutrientCircle(
          label: 'โปรตีน',
          current: current,
          limit: limit,
          unit: 'g',
        ),
      ),
    );
  }

  testWidgets('NutrientCircle displays correct texts and green color for normal level', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(20.0, 100.0));
    await tester.pumpAndSettle();

    expect(find.text('โปรตีน'), findsOneWidget);
    expect(find.text('20.0 / 100.0 g'), findsOneWidget);
    expect(find.text('20%'), findsOneWidget);

    final indicatorFinder = find.byType(CircularPercentIndicator);
    expect(indicatorFinder, findsOneWidget);
    
    final indicator = tester.widget<CircularPercentIndicator>(indicatorFinder);
    expect(indicator.progressColor, Colors.green);
  });

  testWidgets('NutrientCircle displays orange color when near limit', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(85.0, 100.0));
    await tester.pumpAndSettle();

    final indicatorFinder = find.byType(CircularPercentIndicator);
    final indicator = tester.widget<CircularPercentIndicator>(indicatorFinder);
    expect(indicator.progressColor, Colors.orange);
  });

  testWidgets('NutrientCircle displays red color when over limit', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(110.0, 100.0));
    await tester.pumpAndSettle();

    expect(find.text('100%'), findsOneWidget);

    final indicatorFinder = find.byType(CircularPercentIndicator);
    final indicator = tester.widget<CircularPercentIndicator>(indicatorFinder);
    expect(indicator.progressColor, Colors.redAccent);
  });
}
