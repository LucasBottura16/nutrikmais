import 'package:flutter/material.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs/components/custom_button.dart';
import 'package:nutrikmais/globals/customs/components/custom_input_field.dart';

class MealItem {
  String foodName;
  int weight;
  int calories;
  List<String> suggestions;

  MealItem({
    required this.foodName,
    required this.weight,
    required this.calories,
    this.suggestions = const [],
  }) {
    suggestions = List<String>.from(suggestions);
  }
}

/// Modal para visualizar e gerenciar sugestões de um alimento
void showSuggestionsDialog({
  required BuildContext context,
  required MealItem item,
  required bool isEditMode,
  required Function(String suggestion) onAddSuggestion,
  required Function(int index) onRemoveSuggestion,
}) {
  final TextEditingController suggestionController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sugestões'),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alimento: ${item.foodName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Peso: ${item.weight}g - ${item.calories} cal',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'SUGESTÕES DE SUBSTITUIÇÃO',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  if (item.suggestions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Nenhuma sugestão adicionada',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    )
                  else
                    ...item.suggestions.asMap().entries.map((entry) {
                      int index = entry.key;
                      String suggestion = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.swap_horiz,
                                size: 16,
                                color: MyColors.myPrimary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  suggestion,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              if (isEditMode)
                                GestureDetector(
                                  onTap: () {
                                    setDialogState(() {
                                      item.suggestions.removeAt(index);
                                      onRemoveSuggestion(index);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  const Divider(),
                  const SizedBox(height: 8),
                  if (isEditMode) ...[
                    CustomInputField(
                      controller: suggestionController,
                      hintText: 'Ex: Frango grelhado',
                      labelText: 'Adicionar Sugestão',
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: () {
                          if (suggestionController.text.isEmpty) {
                            return;
                          }
                          setDialogState(() {
                            item.suggestions.add(suggestionController.text);
                            onAddSuggestion(suggestionController.text);
                          });
                          suggestionController.clear();
                        },
                        title: "Adicionar Sugestão",
                        titleColor: Colors.white,
                        titleSize: 12,
                        buttonColor: MyColors.myPrimary,
                        buttonEdgeInsets: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),
                    ),
                  ] else
                    Center(
                      child: Text(
                        'Ative o modo de edição para adicionar sugestões',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
