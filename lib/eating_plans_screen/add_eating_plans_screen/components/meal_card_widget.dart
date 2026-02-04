import 'package:flutter/material.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs/components/custom_button.dart';
import 'package:nutrikmais/eating_plans_screen/add_eating_plans_screen/types/eating_plans_types.dart';
import 'package:nutrikmais/eating_plans_screen/add_eating_plans_screen/modals/add_food_modal.dart';
import 'package:nutrikmais/eating_plans_screen/add_eating_plans_screen/modals/suggestions_modal.dart';

class MealCardWidget extends StatefulWidget {
  final MealCard meal;
  final List<String> days;
  final bool isEditMode;
  final VoidCallback onRemove;
  final Function(String, int, int) onAddItem;
  final Function(int) onRemoveItem;
  final VoidCallback onDayChanged;

  const MealCardWidget({
    required this.meal,
    required this.days,
    required this.isEditMode,
    required this.onRemove,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onDayChanged,
    super.key,
  });

  @override
  State<MealCardWidget> createState() => _MealCardWidgetState();
}

class _MealCardWidgetState extends State<MealCardWidget> {
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.meal.mealName.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${widget.meal.totalCalories} calorias',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: widget.onRemove,
                  child: const Icon(Icons.close, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            if (widget.meal.items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Nenhum alimento adicionado',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              )
            else
              ...widget.meal.items.asMap().entries.map((entry) {
                int itemIndex = entry.key;
                MealItem item = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => showSuggestionsDialog(
                      context: context,
                      item: item,
                      isEditMode: widget.isEditMode,
                      onAddSuggestion: (suggestion) {
                        setState(() {});
                      },
                      onRemoveSuggestion: (index) {
                        setState(() {});
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
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
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
                              const Icon(
                                Icons.touch_app,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => widget.onRemoveItem(itemIndex),
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
              }),
            const SizedBox(height: 12),
            const Text(
              'DIAS DA SEMANA',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: widget.days.map((day) {
                bool isSelected = widget.meal.selectedDays.contains(day);
                return GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      widget.meal.selectedDays.remove(day);
                    } else {
                      widget.meal.selectedDays.add(day);
                    }
                    widget.onDayChanged();
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
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () {
                  showAddFoodDialog(
                    context: context,
                    foodNameController: _foodNameController,
                    weightController: _weightController,
                    caloriesController: _caloriesController,
                    onAddFood: (foodName, weight, calories) {
                      widget.onAddItem(foodName, weight, calories);
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
            ),
          ],
        ),
      ),
    );
  }
}
