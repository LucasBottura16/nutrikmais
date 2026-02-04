import 'package:flutter/material.dart';
import 'package:nutrikmais/eating_plans_screen/models/eating_plans_model.dart';
import 'package:nutrikmais/eating_plans_screen/eating_plan_details_screen/eating_plan_details_service.dart';
import 'package:nutrikmais/globals/customs/Widgets/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs/components/custom_button.dart';
import 'package:nutrikmais/eating_plans_screen/add_eating_plans_screen/modals/suggestions_modal.dart';
import 'package:nutrikmais/eating_plans_screen/add_eating_plans_screen/modals/add_food_modal.dart';

class EatingPlanDetailsView extends StatefulWidget {
  const EatingPlanDetailsView({super.key, required this.eatingPlanData});

  final DBEatingPlans eatingPlanData;

  @override
  State<EatingPlanDetailsView> createState() => _EatingPlanDetailsViewState();
}

class _EatingPlanDetailsViewState extends State<EatingPlanDetailsView> {
  final List<String> _days = ['SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SAB', 'DOM'];
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  String _selectedDay = 'SEG';
  List<MealDetail> _parsedMeals = [];
  bool _isEditingMode = false;
  String _typeUser = "";

  @override
  void initState() {
    super.initState();
    _parseMealData();
    _verifyAccount();
  }

  Future<void> _verifyAccount() async {
    final typeUser = await EatingPlanDetailsService.getUserType();
    setState(() {
      _typeUser = typeUser;
    });
  }

  void _parseMealData() {
    _parsedMeals = EatingPlanDetailsService.parseMealData(
      widget.eatingPlanData.eatingPlans,
    );
  }

  List<MealDetail> _getMealsForSelectedDay() {
    return EatingPlanDetailsService.getMealsForSelectedDay(
      _parsedMeals,
      _selectedDay,
    );
  }

  Future<void> _saveChanges() async {
    try {
      await EatingPlanDetailsService.saveChanges(
        widget.eatingPlanData.uidEatingPlans,
        _parsedMeals,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alterações salvas com sucesso!'),
          backgroundColor: MyColors.myPrimary,
        ),
      );

      setState(() {
        _isEditingMode = false;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar alterações: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mealsForDay = _getMealsForSelectedDay();

    return Scaffold(
      appBar: CustomAppBar(
        title: "Planos Alim.",
        backgroundColor: MyColors.myPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botão de Editar/Cancelar - apenas para nutricionistas
            if (EatingPlanDetailsService.isNutritionist(_typeUser))
              CustomButton(
                onPressed: () {
                  setState(() {
                    _isEditingMode = !_isEditingMode;
                  });
                  _isEditingMode ? null : _saveChanges();
                },
                title: _isEditingMode ? "Salvar" : "Editar",
                titleColor: Colors.white,
                titleSize: 12,
                buttonColor: _isEditingMode ? Colors.grey : MyColors.myPrimary,
                buttonEdgeInsets: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
              ),
            const SizedBox(height: 16),
            // Botões de dias da semana
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _days.map((day) {
                  bool isSelected = day == _selectedDay;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDay = day;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? MyColors.myPrimary
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          day,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            // Lista de refeições
            Expanded(
              child: mealsForDay.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma refeição para este dia',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: mealsForDay.length,
                      itemBuilder: (context, index) {
                        final meal = mealsForDay[index];
                        return _buildMealCard(meal);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(MealDetail meal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMealHeader(meal),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              _buildMealItems(meal),
              const SizedBox(height: 12),
              _buildDaysSection(meal),
              const SizedBox(height: 12),
              if (_isEditingMode) _buildAddFoodButton(meal),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealHeader(MealDetail meal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meal.mealName.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '${meal.totalCalories} calorias',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMealItems(MealDetail meal) {
    if (meal.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Nenhum alimento adicionado',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: meal.items.map((item) => _buildFoodItem(meal, item)).toList(),
    );
  }

  Widget _buildFoodItem(MealDetail meal, MealDetailItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => showSuggestionsDialog(
          context: context,
          item: MealItem(
            foodName: item.foodName,
            weight: item.weight,
            calories: item.calories,
            suggestions: item.suggestions,
          ),
          isEditMode: _isEditingMode,
          onAddSuggestion: (suggestion) {
            setState(() {
              item.suggestions.add(suggestion);
            });
          },
          onRemoveSuggestion: (index) {
            setState(() {
              item.suggestions.removeAt(index);
            });
          },
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.foodName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'peso: ${item.weight}g - ${item.calories} calorias',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    if (item.suggestions.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.swap_horiz,
                            size: 12,
                            color: MyColors.myPrimary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${item.suggestions.length} sugestão(ões) de substituição',
                              style: const TextStyle(
                                fontSize: 10,
                                color: MyColors.myPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.touch_app, color: Colors.grey, size: 16),
                  const SizedBox(width: 8),
                  if (_isEditingMode)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          meal.items.remove(item);
                          EatingPlanDetailsService.recalculateMealCalories(
                            meal,
                          );
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaysSection(MealDetail meal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DIAS DA SEMANA',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Opacity(
          opacity: _isEditingMode ? 1.0 : 0.5,
          child: IgnorePointer(
            ignoring: !_isEditingMode,
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _days.map((day) {
                bool isSelected = meal.days.contains(day);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        meal.days.remove(day);
                      } else {
                        meal.days.add(day);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? MyColors.myPrimary : Colors.grey[300],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddFoodButton(MealDetail meal) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        onPressed: () {
          showAddFoodDialog(
            context: context,
            foodNameController: _foodNameController,
            weightController: _weightController,
            caloriesController: _caloriesController,
            onAddFood: (foodName, weight, calories) {
              setState(() {
                meal.items.add(
                  MealDetailItem(
                    foodName: foodName,
                    weight: weight,
                    calories: calories,
                  ),
                );
                EatingPlanDetailsService.recalculateMealCalories(meal);
              });
            },
          );
        },
        title: "adicionar alimento",
        titleColor: Colors.white,
        titleSize: 14,
        buttonColor: MyColors.myPrimary,
        buttonEdgeInsets: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
      ),
    );
  }
}
