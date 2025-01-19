import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_category_app_flutter/models/meal.dart';

class FavouiteMealsNotifier extends StateNotifier<List<Meal>> {
  FavouiteMealsNotifier() : super([]);

  bool toggleMealFavoriteStatus(Meal meal) {
    final isExisting = state.contains(meal);
    if (isExisting) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavouiteMealsNotifier, List<Meal>>((ref) {
  return FavouiteMealsNotifier();
});
