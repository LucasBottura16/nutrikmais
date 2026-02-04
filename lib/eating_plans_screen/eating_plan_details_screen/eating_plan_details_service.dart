import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrikmais/globals/hooks/use_user_type.dart';

class MealDetailItem {
  String foodName;
  int weight;
  int calories;
  List<String> suggestions;

  MealDetailItem({
    required this.foodName,
    required this.weight,
    required this.calories,
    this.suggestions = const [],
  }) {
    suggestions = List<String>.from(suggestions);
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

  static List<MealDetail> parseMealData(List<String> eatingPlans) {
    List<MealDetail> parsedMeals = [];

    for (var mealString in eatingPlans) {
      try {
        // Parse format: "Nome - Calorias\nDias: ...\nItens: ..."
        final lines = mealString.split('\n');

        // Parse first line for meal name and calories
        final firstLine = lines[0];
        final firstLineParts = firstLine.split(' - ');
        final mealName = firstLineParts[0].trim();
        final caloriesText = firstLineParts.length > 1
            ? firstLineParts[1].replaceAll(' calorias', '').trim()
            : '0';
        final totalCalories = int.tryParse(caloriesText) ?? 0;

        // Parse days
        List<String> days = [];
        if (lines.length > 1 && lines[1].startsWith('Dias:')) {
          final daysText = lines[1].replaceAll('Dias:', '').trim();
          days = daysText.split(',').map((d) => d.trim()).toList();
        }

        // Parse items with suggestions
        List<MealDetailItem> items = [];
        if (lines.length > 2 && lines[2].startsWith('Itens:')) {
          final itemsText = lines[2].replaceAll('Itens:', '').trim();

          // Split by "), " but handle suggestions in brackets
          final itemsList = <String>[];
          var currentItem = '';
          var bracketDepth = 0;

          for (var i = 0; i < itemsText.length; i++) {
            final char = itemsText[i];
            if (char == '[') bracketDepth++;
            if (char == ']') bracketDepth--;

            currentItem += char;

            // Check if we're at a delimiter and not inside brackets
            if (i < itemsText.length - 2 &&
                itemsText.substring(i, i + 2) == ', ' &&
                bracketDepth == 0) {
              itemsList.add(currentItem.trim());
              currentItem = '';
              i++; // Skip the space after comma
            }
          }
          if (currentItem.trim().isNotEmpty) {
            itemsList.add(currentItem.trim());
          }

          for (var itemStr in itemsList) {
            // Format: "alimento(peso,cal)[sug1|sug2|...]" or "alimento(peso,cal)[]"
            final match = RegExp(
              r'(.+?)\((\d+)g,(\d+)cal\)\[(.*)\]',
            ).firstMatch(itemStr);

            if (match != null) {
              final suggestionsStr = match.group(4)!;
              final suggestions = suggestionsStr.isEmpty
                  ? <String>[]
                  : suggestionsStr.split('|');

              items.add(
                MealDetailItem(
                  foodName: match.group(1)!.trim(),
                  weight: int.parse(match.group(2)!),
                  calories: int.parse(match.group(3)!),
                  suggestions: suggestions,
                ),
              );
            }
          }
        }

        parsedMeals.add(
          MealDetail(
            mealName: mealName,
            totalCalories: totalCalories,
            days: days,
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

  static List<String> convertMealsToString(List<MealDetail> meals) {
    return meals.map((meal) {
      String itemsString = meal.items
          .map((item) {
            String suggestions = item.suggestions.isNotEmpty
                ? '[${item.suggestions.join('|')}]'
                : '[]';
            return '${item.foodName}(${item.weight}g,${item.calories}cal)$suggestions';
          })
          .join(', ');
      return '${meal.mealName} - ${meal.totalCalories} calorias\nDias: ${meal.days.join(', ')}\nItens: $itemsString';
    }).toList();
  }

  static Future<void> saveChanges(
    String uidEatingPlans,
    List<MealDetail> meals,
  ) async {
    try {
      final eatingPlansData = convertMealsToString(meals);

      await FirebaseFirestore.instance
          .collection('EatingPlans')
          .doc(uidEatingPlans)
          .update({
            'eatingPlans': eatingPlansData,
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
