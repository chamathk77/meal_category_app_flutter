import 'package:flutter/material.dart';
import 'package:meal_category_app_flutter/data/dummy_data.dart';
import 'package:meal_category_app_flutter/models/meal.dart';
import 'package:meal_category_app_flutter/screens/categories.dart';
import 'package:meal_category_app_flutter/screens/filters.dart';
import 'package:meal_category_app_flutter/screens/meals.dart';
import 'package:meal_category_app_flutter/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> favoriteMeals = [];
  Map<Filter, bool> _Selectedfilters = kInitialFilters;
  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = favoriteMeals.contains(meal);
    if (isExisting) {
      _showInfoMessage('Meal is no longer a favorite.');
      setState(() {
        favoriteMeals.remove(meal);
      });
    } else {
      setState(() {
        favoriteMeals.add(meal);
      });
      _showInfoMessage('Marked as favorite.');
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final availbleMeals = dummyMeals.where((meal) {
      if (_Selectedfilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_Selectedfilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_Selectedfilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_Selectedfilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availbleMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }

    void _setScreen(String identifier) async {
      Navigator.of(context).pop();
      if (identifier == 'filters') {
        final result = await Navigator.of(context).push<Map<Filter, bool>>(
          MaterialPageRoute(
            builder: (ctx) => FiltersScreen(
              currentFilters: _Selectedfilters,
            ),
          ),
        );

        setState(() {
          _Selectedfilters = result ?? kInitialFilters;
        });
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
