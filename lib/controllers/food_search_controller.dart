import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../models/isar/food_item.dart';
import '../providers/core_providers.dart';
import '../repositories/food_repository.dart';

// State สำหรับหน้า Food Search
class FoodSearchState {
  final bool isLoading;
  final List<FoodItem> results;
  final String query;

  FoodSearchState({
    this.isLoading = false,
    this.results = const [],
    this.query = '',
  });

  FoodSearchState copyWith({
    bool? isLoading,
    List<FoodItem>? results,
    String? query,
  }) {
    return FoodSearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      query: query ?? this.query,
    );
  }
}

final foodSearchControllerProvider = StateNotifierProvider.autoDispose<FoodSearchController, FoodSearchState>((ref) {
  return FoodSearchController(ref.watch(foodRepositoryProvider));
});

class FoodSearchController extends StateNotifier<FoodSearchState> {
  final FoodRepository _repo;
  Timer? _debounce;

  FoodSearchController(this._repo) : super(FoodSearchState()) {
    // Initial search
    search('');
  }

  void search(String query) {
    state = state.copyWith(query: query, isLoading: true);

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final results = await _repo.searchFood(query);
      if (!mounted) return;
      state = state.copyWith(isLoading: false, results: results);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
