import 'package:flutter/material.dart';
import 'package:nutrikmais/globals/customs/Widgets/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs/Widgets/select_schedule_patient_modal.dart';
import 'package:nutrikmais/eating_plans_screen/add_eating_plans_screen/add_eating_plans_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrikmais/globals/customs/components/custom_button.dart';
import 'package:nutrikmais/eating_plans_screen/add_eating_plans_screen/modals/add_meal_modal.dart';
import 'package:nutrikmais/eating_plans_screen/add_eating_plans_screen/modals/suggestions_modal.dart';
import 'package:nutrikmais/eating_plans_screen/add_eating_plans_screen/types/eating_plans_types.dart';
import 'package:nutrikmais/eating_plans_screen/add_eating_plans_screen/components/meal_card_widget.dart';
import 'package:nutrikmais/eating_plans_screen/models/eating_plans_model.dart';

class AddEatingPlansView extends StatefulWidget {
  const AddEatingPlansView({super.key});

  @override
  State<AddEatingPlansView> createState() => _AddEatingPlansViewState();
}

class _AddEatingPlansViewState extends State<AddEatingPlansView> {
  QueryDocumentSnapshot? _selectedConsultation;
  final AddEatingPlansService _service = AddEatingPlansService();
  final List<MealCard> _mealCards = [];

  bool _isLoading = false;
  final List<String> _days = ['SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SAB', 'DOM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Adicionar Plano Alimentar",
        backgroundColor: MyColors.myPrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'SELECIONAR CONSULTA',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _selectedConsultation != null
                        ? GestureDetector(
                            onTap: () async {
                              final consultations = await _service
                                  .getScheduledConsultations();

                              final selected = await selectSchedulePatientModal(
                                context,
                                consultations,
                              );

                              if (selected != null) {
                                setState(() {
                                  _selectedConsultation = selected;
                                });
                              }
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ((_selectedConsultation!.data()
                                                        as Map<
                                                          String,
                                                          dynamic
                                                        >)['patient']) ??
                                                    '',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.access_time,
                                                    size: 14,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${(_selectedConsultation!.data() as Map<String, dynamic>)['dateConsultation'] ?? ''}  ${(_selectedConsultation!.data() as Map<String, dynamic>)['timeConsultation'] ?? ''}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    size: 14,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      '${(_selectedConsultation!.data() as Map<String, dynamic>)['serviceName'] ?? ''} - ${(_selectedConsultation!.data() as Map<String, dynamic>)['place'] ?? ''}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Color.fromARGB(
                                                          255,
                                                          197,
                                                          33,
                                                          33,
                                                        ),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: MyColors.myPrimary
                                                .withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.check_circle,
                                            color: MyColors.myPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              final consultations = await _service
                                  .getScheduledConsultations();

                              final selected = await selectSchedulePatientModal(
                                context,
                                consultations,
                              );

                              if (selected != null) {
                                setState(() {
                                  _selectedConsultation = selected;
                                });
                              }
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Selecione uma consulta",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: MyColors.myPrimary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 24),
                    const Text(
                      'REFEIÇÕES',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    if (_mealCards.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            'Clique no + abaixo para adicionar refeições',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      )
                    else
                      ..._mealCards.asMap().entries.map((entry) {
                        int index = entry.key;
                        MealCard meal = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: MealCardWidget(
                            meal: meal,
                            days: _days,
                            isEditMode: true,
                            onRemove: () {
                              setState(() {
                                _mealCards.removeAt(index);
                              });
                            },
                            onAddItem:
                                (
                                  foodName,
                                  weight,
                                  calories,
                                  protein,
                                  lipids,
                                  carbs,
                                ) {
                                  setState(() {
                                    meal.items.add(
                                      MealItem(
                                        foodName: foodName,
                                        weight: weight,
                                        calories: calories,
                                        protein: protein,
                                        lipids: lipids,
                                        carbs: carbs,
                                      ),
                                    );
                                    int newTotalCalories = 0;
                                    double newTotalProtein = 0;
                                    double newTotalLipids = 0;
                                    double newTotalCarbs = 0;
                                    for (var item in meal.items) {
                                      newTotalCalories += item.calories;
                                      newTotalProtein += item.protein;
                                      newTotalLipids += item.lipids;
                                      newTotalCarbs += item.carbs;
                                    }
                                    meal.totalCalories = newTotalCalories;
                                    meal.totalProtein = newTotalProtein;
                                    meal.totalLipids = newTotalLipids;
                                    meal.totalCarbs = newTotalCarbs;
                                  });
                                },
                            onRemoveItem: (itemIndex) {
                              setState(() {
                                meal.items.removeAt(itemIndex);
                                int newTotalCalories = 0;
                                double newTotalProtein = 0;
                                double newTotalLipids = 0;
                                double newTotalCarbs = 0;
                                for (var item in meal.items) {
                                  newTotalCalories += item.calories;
                                  newTotalProtein += item.protein;
                                  newTotalLipids += item.lipids;
                                  newTotalCarbs += item.carbs;
                                }
                                meal.totalCalories = newTotalCalories;
                                meal.totalProtein = newTotalProtein;
                                meal.totalLipids = newTotalLipids;
                                meal.totalCarbs = newTotalCarbs;
                              });
                            },
                            onDayChanged: () {
                              setState(() {});
                            },
                          ),
                        );
                      }),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: MyColors.myPrimary,
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            showAddMealDialog(
                              context: context,
                              onAddMeal: (mealName, calories) {
                                setState(() {
                                  _mealCards.add(
                                    MealCard(
                                      mealName: mealName,
                                      totalCalories: calories,
                                      items: [],
                                    ),
                                  );
                                });
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.add,
                            color: MyColors.myPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () async {
                  if (_selectedConsultation == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Selecione uma consulta')),
                    );
                    return;
                  }

                  if (_mealCards.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Adicione pelo menos uma refeição'),
                      ),
                    );
                    return;
                  }

                  bool hasAnyDaySelected = _mealCards.any(
                    (meal) => meal.selectedDays.isNotEmpty,
                  );
                  if (!hasAnyDaySelected) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Selecione pelo menos um dia da semana em alguma refeição',
                        ),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    List<EatingPlanMeal> eatingPlansData = _mealCards.map((
                      meal,
                    ) {
                      return EatingPlanMeal(
                        mealName: meal.mealName,
                        totalCalories: meal.totalCalories,
                        totalProtein: meal.totalProtein,
                        totalLipids: meal.totalLipids,
                        totalCarbs: meal.totalCarbs,
                        days: meal.selectedDays,
                        items: meal.items
                            .map(
                              (item) => EatingPlanItem(
                                foodName: item.foodName,
                                weight: item.weight,
                                calories: item.calories,
                                protein: item.protein,
                                lipids: item.lipids,
                                carbs: item.carbs,
                                suggestions: item.suggestions
                                    .map(
                                      (sug) => EatingPlanSuggestion(
                                        foodName: sug.foodName,
                                        weight: sug.weight,
                                        calories: sug.calories,
                                        protein: sug.protein,
                                        lipids: sug.lipids,
                                        carbs: sug.carbs,
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                            .toList(),
                      );
                    }).toList();

                    await _service.completedRegister(
                      (_selectedConsultation!.data()
                          as Map<String, dynamic>)['uidAccount'],
                      (_selectedConsultation!.data()
                          as Map<String, dynamic>)['patient'],
                      eatingPlansData,
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao salvar plano alimentar: $e'),
                      ),
                    );
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                    }
                  }
                },
                title: "SALVAR PLANO ALIMENTAR",
                titleColor: Colors.white,
                titleSize: 16,
                buttonEdgeInsets: const EdgeInsets.symmetric(vertical: 20),
                buttonColor: MyColors.myPrimary,
                buttonBorderRadius: 0,
                isLoading: _isLoading,
                loadingColor: MyColors.myPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
