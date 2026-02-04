import 'package:flutter/material.dart';
import 'package:nutrikmais/globals/customs/components/custom_input_field.dart';

/// Modal para adicionar um novo alimento
void showAddFoodDialog({
  required BuildContext context,
  required TextEditingController foodNameController,
  required TextEditingController weightController,
  required TextEditingController caloriesController,
  required Function(String foodName, int weight, int calories) onAddFood,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Adicionar Alimento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomInputField(
              controller: foodNameController,
              hintText: 'nome do alimento',
              labelText: 'Alimento',
            ),
            const SizedBox(height: 12),
            CustomInputField(
              controller: weightController,
              hintText: 'Ex: 150 (g)',
              labelText: 'Medidas',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            CustomInputField(
              controller: caloriesController,
              hintText: 'Ex: 90',
              labelText: 'Calorias',
              keyboardType: TextInputType.number,
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
              if (foodNameController.text.isEmpty ||
                  weightController.text.isEmpty ||
                  caloriesController.text.isEmpty) {
                return;
              }

              onAddFood(
                foodNameController.text,
                int.parse(weightController.text),
                int.parse(caloriesController.text),
              );

              foodNameController.clear();
              weightController.clear();
              caloriesController.clear();

              Navigator.pop(context);
            },
            child: const Text('Adicionar'),
          ),
        ],
      );
    },
  );
}
