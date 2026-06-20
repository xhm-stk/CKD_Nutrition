import 'package:flutter_test/flutter_test.dart';
import 'package:ckd_nutrition_app/services/biometric_service.dart';

void main() {
  test('BiometricService initialization', () {
    final service = BiometricService();
    expect(service, isNotNull);
    expect(service, isA<BiometricService>());
  });
}
