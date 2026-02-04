import 'package:flutter/material.dart';
import 'package:nutrikmais/globals/customs/components/custom_input_field.dart';

void showAddMealDialog({
  required BuildContext context,
  required Function(String mealName, int calories) onAddMeal,
}) {
  final TextEditingController mealNameController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Adicionar Refeição'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomInputField(
              controller: mealNameController,
              hintText: 'Ex: Café da Manhã',
              labelText: 'Nome da Refeição',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (mealNameController.text.isEmpty) {
                return;
              }

              onAddMeal(mealNameController.text, 0);
              Navigator.pop(context);
            },
            child: const Text('Adicionar'),
          ),
        ],
      );
    },
  );
}
