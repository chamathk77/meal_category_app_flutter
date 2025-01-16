import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_category_app_flutter/data/dummy_data.dart';

final mealsProvider = StateProvider((ref) {
  return dummyMeals;
});
