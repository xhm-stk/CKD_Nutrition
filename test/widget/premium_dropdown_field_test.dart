import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ckd_nutrition_app/widgets/premium_dropdown_field.dart';

void main() {
  testWidgets('PremiumDropdownField renders and can be interacted with', (
    tester,
  ) async {
    String? selectedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PremiumDropdownField<String>(
            label: 'Test Dropdown',
            value: 'A',
            prefixIcon: Icons.star,
            items: const [
              DropdownMenuItem(value: 'A', child: Text('Option A')),
              DropdownMenuItem(value: 'B', child: Text('Option B')),
            ],
            onChanged: (val) {
              selectedValue = val;
            },
          ),
        ),
      ),
    );

    expect(find.text('Test Dropdown'), findsOneWidget);
    expect(find.text('Option A'), findsOneWidget);

    await tester.tap(find.text('Option A'));
    await tester.pumpAndSettle();

    expect(find.text('Option B'), findsOneWidget);
    await tester.tap(find.text('Option B'));
    await tester.pumpAndSettle();

    expect(selectedValue, 'B');
  });
}
