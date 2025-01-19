import 'package:flutter/material.dart';
import 'package:meal_category_app_flutter/data/dummy_data.dart';
import 'package:meal_category_app_flutter/models/meal.dart';
import 'package:meal_category_app_flutter/screens/categories.dart';
import 'package:meal_category_app_flutter/screens/filters.dart';
import 'package:meal_category_app_flutter/screens/meals.dart';
import 'package:meal_category_app_flutter/widgets/main_drawer.dart';

import 'package:meal_category_app_flutter/providers/meals_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_category_app_flutter/providers/favourite_provider.dart';

import 'package:meal_category_app_flutter/providers/filter_provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final activeFilters = ref.watch(filtersProvider);
    final availbleMeals = ref.watch(filteredMealsProvider);

    Widget activePage = CategoriesScreen(
      // onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availbleMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favMeals = ref.watch(favoriteMealsProvider);

      activePage = MealsScreen(
        meals: favMeals,
        // onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }

    void _setScreen(String identifier) async {
      Navigator.of(context).pop();
      if (identifier == 'filters') {
        await Navigator.of(context).push<Map<Filter, bool>>(
          MaterialPageRoute(
            builder: (ctx) => FiltersScreen(),
          ),
        );
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(activePageTitle),
        ),
        drawer: MainDrawer(
          onSelectScreen: _setScreen,
        ),
        body: activePage,
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.set_meal), label: 'Categories'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
          ],
        ));
  }
}
