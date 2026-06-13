import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final url = dotenv.env['SUPABASE_URL']!;
  final key = dotenv.env['SUPABASE_ANON_KEY']!;
  final client = SupabaseClient(url, key);

  test('Check Supabase Column created_at', () async {
    try {
      await client.from('meals').select('created_at').limit(1);
      debugPrint('created_at EXISTS');
    } catch (e) {
      debugPrint('created_at ERROR: $e');
    }
  });

  test('Check Supabase Column eaten_at', () async {
    try {
      await client.from('meals').select('eaten_at').limit(1);
      debugPrint('eaten_at EXISTS');
    } catch (e) {
      debugPrint('eaten_at ERROR: $e');
    }
  });
}
