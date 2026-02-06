import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrikmais/globals/hooks/use_user_type.dart';
import 'package:nutrikmais/eating_plans_screen/add_eating_plans_screen/modals/suggestions_modal.dart';
import 'package:nutrikmais/eating_plans_screen/models/eating_plans_model.dart';

class MealDetailItem {
  String foodName;
  int weight;
  int calories;
  double protein;
  double lipids;
  double carbs;
  List<SuggestionItem> suggestions;

  MealDetailItem({
    required this.foodName,
    required this.weight,
    required this.calories,
    this.protein = 0,
    this.lipids = 0,
    this.carbs = 0,
    this.suggestions = const [],
  }) {
    suggestions = List<SuggestionItem>.from(suggestions);
  }
}

class MealDetail {
  String mealName;
  int totalCalories;
  List<String> days;
  List<MealDetailItem> items;

  MealDetail({
    required this.mealName,
    required this.totalCalories,
    required this.days,
    required this.items,
  });
}

class EatingPlanDetailsService {
  static Future<String> getUserType() async {
    final userPrefs = await useUserPreferences();
    return userPrefs.typeUser;
  }

  static List<MealDetail> parseMealData(List<EatingPlanMeal> eatingPlans) {
    List<MealDetail> parsedMeals = [];

    for (var meal in eatingPlans) {
      try {
        List<MealDetailItem> items = meal.items.map((item) {
          List<SuggestionItem> suggestions = item.suggestions.map((sug) {
            return SuggestionItem(
              foodName: sug.foodName,
              weight: sug.weight,
              calories: sug.calories,
              protein: sug.protein,
              lipids: sug.lipids,
              carbs: sug.carbs,
            );
          }).toList();

          return MealDetailItem(
            foodName: item.foodName,
            weight: item.weight,
            calories: item.calories,
            protein: item.protein,
            lipids: item.lipids,
            carbs: item.carbs,
            suggestions: suggestions,
          );
        }).toList();

        parsedMeals.add(
          MealDetail(
            mealName: meal.mealName,
            totalCalories: meal.totalCalories,
            days: meal.days,
            items: items,
          ),
        );
      } catch (e) {
        debugPrint('Error parsing meal: $e');
      }
    }

    return parsedMeals;
  }

  static List<MealDetail> getMealsForSelectedDay(
    List<MealDetail> meals,
    String selectedDay,
  ) {
    return meals.where((meal) {
      return meal.days.contains(selectedDay);
    }).toList();
  }

  static List<EatingPlanMeal> convertMealsToEatingPlanMeal(
    List<MealDetail> meals,
  ) {
    return meals.map((meal) {
      double totalProtein = 0;
      double totalLipids = 0;
      double totalCarbs = 0;

      List<EatingPlanItem> items = meal.items.map((item) {
        totalProtein += item.protein;
        totalLipids += item.lipids;
        totalCarbs += item.carbs;

        List<EatingPlanSuggestion> suggestions = item.suggestions.map((sug) {
          return EatingPlanSuggestion(
            foodName: sug.foodName,
            weight: sug.weight,
            calories: sug.calories,
            protein: sug.protein,
            lipids: sug.lipids,
            carbs: sug.carbs,
          );
        }).toList();

        return EatingPlanItem(
          foodName: item.foodName,
          weight: item.weight,
          calories: item.calories,
          protein: item.protein,
          lipids: item.lipids,
          carbs: item.carbs,
          suggestions: suggestions,
        );
      }).toList();

      return EatingPlanMeal(
        mealName: meal.mealName,
        totalCalories: meal.totalCalories,
        totalProtein: totalProtein,
        totalLipids: totalLipids,
        totalCarbs: totalCarbs,
        days: meal.days,
        items: items,
      );
    }).toList();
  }

  static Future<void> saveChanges(
    String uidEatingPlans,
    List<MealDetail> meals,
  ) async {
    try {
      final eatingPlansData = convertMealsToEatingPlanMeal(meals);
      final eatingPlansMap = eatingPlansData
          .map((meal) => meal.toMap())
          .toList();

      await FirebaseFirestore.instance
          .collection('EatingPlans')
          .doc(uidEatingPlans)
          .update({
            'eatingPlans': eatingPlansMap,
            'eatingPlansUpdatedAt': DateFormat(
              'dd/MM/yyyy',
            ).format(DateTime.now()),
          });
    } catch (e) {
      rethrow;
    }
  }

  static bool isNutritionist(String typeUser) {
    return typeUser != "patient";
  }

  static void recalculateMealCalories(MealDetail meal) {
    meal.totalCalories = meal.items.fold(0, (sum, item) => sum + item.calories);
  }
}
