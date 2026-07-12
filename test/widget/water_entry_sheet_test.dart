import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ckd_nutrition_app/pages/dashboard/widgets/water_entry_sheet.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ckd_nutrition_app/l10n/app_localizations.dart';

void main() {
  testWidgets('WaterEntrySheet quick buttons call onSave', (tester) async {
    int? savedMl;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('th', ''), Locale('en', '')],
        locale: const Locale('th', ''),
        home: Scaffold(
          body: WaterEntrySheet(
            onSave: (ml) async {
              savedMl = ml;
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify quick buttons render
    expect(find.text('+ 100 ml'), findsOneWidget);
    expect(find.text('+ 250 ml'), findsOneWidget);
    expect(find.text('+ 500 ml'), findsOneWidget);

    // Tap quick button
    await tester.tap(find.text('+ 250 ml'));
    await tester.pumpAndSettle();

    expect(savedMl, 250);
  });
}
