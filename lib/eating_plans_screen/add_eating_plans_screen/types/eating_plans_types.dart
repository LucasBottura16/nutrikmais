import 'package:nutrikmais/eating_plans_screen/add_eating_plans_screen/modals/suggestions_modal.dart';

class MealCard {
  String mealName;
  int totalCalories;
  double totalProtein;
  double totalLipids;
  double totalCarbs;
  List<MealItem> items;
  List<String> selectedDays;

  MealCard({
    required this.mealName,
    required this.totalCalories,
    this.totalProtein = 0,
    this.totalLipids = 0,
    this.totalCarbs = 0,
    this.items = const [],
    this.selectedDays = const [],
  }) {
    items = List<MealItem>.from(items);
    selectedDays = List<String>.from(selectedDays);
  }
}
