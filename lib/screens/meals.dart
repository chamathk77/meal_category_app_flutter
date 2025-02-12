import 'package:flutter/material.dart';
import 'package:meal_category_app_flutter/main.dart';
import 'package:meal_category_app_flutter/models/meal.dart';
import 'package:meal_category_app_flutter/screens/meal_details.dart';
import 'package:meal_category_app_flutter/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    this.title,
    required this.meals,
    // required this.onToggleFavorite,
  });

  final String? title;
  final List<Meal> meals;

  // final void Function(Meal meal) onToggleFavorite;

  void _selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MealDetailsScreen(
        meal: meal,
        // onToggleFavorite: onToggleFavorite,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget body = ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) {
        return MealItem(meal: meals[index], onSelectMeal: _selectMeal);
      },
    );

    if (meals.isEmpty) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Uh oh!... Nothing here...",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Try selecting a different category!',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ],
        ),
      );
    }
    if (title != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title!),
        ),
        body: body,
      );
    } else {
      return body;
    }
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Meals'),
    //   ),
    //   body: body,
    // );
  }
}
