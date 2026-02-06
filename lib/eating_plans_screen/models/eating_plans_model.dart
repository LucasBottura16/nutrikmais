import 'package:cloud_firestore/cloud_firestore.dart';

class DBEatingPlans {
  String? _uidEatingPlans;
  String? _eatingPlansUpdatedAt;
  String? _uidNutritionist;
  String? _uidAccount;
  String? _patientName;
  List<EatingPlanMeal>? _eatingPlans;

  DBEatingPlans();

  DBEatingPlans.fromDocumentSnapshotEatingPlans(
    DocumentSnapshot documentSnapshot,
  ) {
    uidEatingPlans = documentSnapshot['uidEatingPlans'];
    eatingPlansUpdatedAt = documentSnapshot['eatingPlansUpdatedAt'];
    uidNutritionist = documentSnapshot['uidNutritionist'];
    uidAccount = documentSnapshot['uidAccount'];
    patientName = documentSnapshot['patientName'];

    if (documentSnapshot['eatingPlans'] != null) {
      eatingPlans = (documentSnapshot['eatingPlans'] as List)
          .map((meal) => EatingPlanMeal.fromMap(meal))
          .toList();
    }
  }

  Map<String, dynamic> toMap(uidEatingPlans) {
    Map<String, dynamic> map() {
      return {
        'uidEatingPlans': uidEatingPlans,
        'eatingPlans': _eatingPlans?.map((meal) => meal.toMap()).toList(),
        'eatingPlansUpdatedAt': _eatingPlansUpdatedAt,
        'uidNutritionist': _uidNutritionist,
        'uidAccount': _uidAccount,
        'patientName': _patientName,
      };
    }

    return map();
  }

  String? get patientName => _patientName;
  set patientName(String? value) {
    _patientName = value;
  }

  String get uidEatingPlans => _uidEatingPlans!;
  set uidEatingPlans(String? value) {
    _uidEatingPlans = value;
  }

  List<EatingPlanMeal> get eatingPlans => _eatingPlans!;
  set eatingPlans(List<EatingPlanMeal>? value) {
    _eatingPlans = value;
  }

  String get eatingPlansUpdatedAt => _eatingPlansUpdatedAt!;
  set eatingPlansUpdatedAt(String? value) {
    _eatingPlansUpdatedAt = value;
  }

  String get uidNutritionist => _uidNutritionist!;
  set uidNutritionist(String? value) {
    _uidNutritionist = value;
  }

  String get uidAccount => _uidAccount!;
  set uidAccount(String? value) {
    _uidAccount = value;
  }
}

class EatingPlanMeal {
  String mealName;
  int totalCalories;
  double totalProtein;
  double totalLipids;
  double totalCarbs;
  List<String> days;
  List<EatingPlanItem> items;

  EatingPlanMeal({
    required this.mealName,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalLipids,
    required this.totalCarbs,
    required this.days,
    required this.items,
  });

  factory EatingPlanMeal.fromMap(Map<String, dynamic> map) {
    return EatingPlanMeal(
      mealName: map['mealName'] ?? '',
      totalCalories: map['totalCalories'] ?? 0,
      totalProtein: (map['totalProtein'] ?? 0).toDouble(),
      totalLipids: (map['totalLipids'] ?? 0).toDouble(),
      totalCarbs: (map['totalCarbs'] ?? 0).toDouble(),
      days: List<String>.from(map['days'] ?? []),
      items:
          (map['items'] as List?)
              ?.map((item) => EatingPlanItem.fromMap(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mealName': mealName,
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalLipids': totalLipids,
      'totalCarbs': totalCarbs,
      'days': days,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}

class EatingPlanItem {
  String foodName;
  int weight;
  int calories;
  double protein;
  double lipids;
  double carbs;
  List<EatingPlanSuggestion> suggestions;

  EatingPlanItem({
    required this.foodName,
    required this.weight,
    required this.calories,
    required this.protein,
    required this.lipids,
    required this.carbs,
    required this.suggestions,
  });

  factory EatingPlanItem.fromMap(Map<String, dynamic> map) {
    return EatingPlanItem(
      foodName: map['foodName'] ?? '',
      weight: map['weight'] ?? 0,
      calories: map['calories'] ?? 0,
      protein: (map['protein'] ?? 0).toDouble(),
      lipids: (map['lipids'] ?? 0).toDouble(),
      carbs: (map['carbs'] ?? 0).toDouble(),
      suggestions:
          (map['suggestions'] as List?)
              ?.map((sug) => EatingPlanSuggestion.fromMap(sug))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'weight': weight,
      'calories': calories,
      'protein': protein,
      'lipids': lipids,
      'carbs': carbs,
      'suggestions': suggestions.map((sug) => sug.toMap()).toList(),
    };
  }
}

class EatingPlanSuggestion {
  String foodName;
  int weight;
  int calories;
  double protein;
  double lipids;
  double carbs;

  EatingPlanSuggestion({
    required this.foodName,
    required this.weight,
    required this.calories,
    required this.protein,
    required this.lipids,
    required this.carbs,
  });

  factory EatingPlanSuggestion.fromMap(Map<String, dynamic> map) {
    return EatingPlanSuggestion(
      foodName: map['foodName'] ?? '',
      weight: map['weight'] ?? 0,
      calories: map['calories'] ?? 0,
      protein: (map['protein'] ?? 0).toDouble(),
      lipids: (map['lipids'] ?? 0).toDouble(),
      carbs: (map['carbs'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'weight': weight,
      'calories': calories,
      'protein': protein,
      'lipids': lipids,
      'carbs': carbs,
    };
  }
}
