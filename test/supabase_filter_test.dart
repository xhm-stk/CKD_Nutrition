import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

void main() {
  test('Supabase Filter Test', () {
    final client = SupabaseClient('https://xyz.supabase.co', 'apikey');
    final query = client.from('meals').select().isFilter('deleted_at', null);
    debugPrint(query.toString());
  });
}
