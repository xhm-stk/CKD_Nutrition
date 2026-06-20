import 'package:flutter_test/flutter_test.dart';
import 'package:ckd_nutrition_app/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  
  test('ThemeProvider initialization', () {
    final container = ProviderContainer();
    final themeMode = container.read(themeProvider);
    expect(themeMode, isNotNull);
  });
}
