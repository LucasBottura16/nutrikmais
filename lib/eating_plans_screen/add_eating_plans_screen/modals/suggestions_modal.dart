import 'package:flutter/material.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs/components/custom_button.dart';
import 'package:nutrikmais/globals/customs/components/custom_input_field.dart';
import 'package:nutrikmais/eating_plans_screen/add_eating_plans_screen/modals/select_taco_food_modal.dart';

class SuggestionItem {
  String foodName;
  int weight;
  int calories;
  double protein;
  double lipids;
  double carbs;

  SuggestionItem({
    required this.foodName,
    required this.weight,
    required this.calories,
    this.protein = 0,
    this.lipids = 0,
    this.carbs = 0,
  });
}

class MealItem {
  String foodName;
  int weight;
  int calories;
  double protein;
  double lipids;
  double carbs;
  List<SuggestionItem> suggestions;

  MealItem({
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

/// Modal para visualizar e gerenciar sugestões de um alimento
void showSuggestionsDialog({
  required BuildContext context,
  required MealItem item,
  required bool isEditMode,
  required Function(SuggestionItem suggestion) onAddSuggestion,
  required Function(int index) onRemoveSuggestion,
}) {
  final TextEditingController suggestionController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController lipidsController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();

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
                  if (item.protein > 0 || item.lipids > 0 || item.carbs > 0)
                    Text(
                      'Prot: ${item.protein.toStringAsFixed(1)}g | Lip: ${item.lipids.toStringAsFixed(1)}g | Carb: ${item.carbs.toStringAsFixed(1)}g',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
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
                      SuggestionItem suggestion = entry.value;
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      suggestion.foodName,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${suggestion.weight}g - ${suggestion.calories}cal',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    if (suggestion.protein > 0 ||
                                        suggestion.lipids > 0 ||
                                        suggestion.carbs > 0)
                                      Text(
                                        'P:${suggestion.protein.toStringAsFixed(1)}g | L:${suggestion.lipids.toStringAsFixed(1)}g | C:${suggestion.carbs.toStringAsFixed(1)}g',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
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
                    CustomButton(
                      onPressed: () async {
                        final alimento = await showSelectTacoFoodDialog(
                          context,
                        );

                        if (alimento != null) {
                          // Extrair valores numéricos
                          double energiaKcal = 0;
                          double peso = 100;
                          double protein = 0;
                          double lipids = 0;
                          double carbs = 0;

                          try {
                            final energiaStr = alimento.energiaKcal.replaceAll(
                              ',',
                              '.',
                            );
                            energiaKcal = double.tryParse(energiaStr) ?? 0;

                            final medidaMatch = RegExp(
                              r'(\d+)\s*g',
                            ).firstMatch(alimento.medidaCaseira);
                            if (medidaMatch != null) {
                              peso =
                                  double.tryParse(
                                    medidaMatch.group(1) ?? '100',
                                  ) ??
                                  100;
                            }

                            final proteinStr = alimento.proteinaG.replaceAll(
                              ',',
                              '.',
                            );
                            protein = double.tryParse(proteinStr) ?? 0;

                            final lipidsStr = alimento.lipideosG.replaceAll(
                              ',',
                              '.',
                            );
                            lipids = double.tryParse(lipidsStr) ?? 0;

                            final carbsStr = alimento.carboidratoG.replaceAll(
                              ',',
                              '.',
                            );
                            carbs = double.tryParse(carbsStr) ?? 0;
                          } catch (e) {
                            // Usar valores padrão
                          }

                          setDialogState(() {
                            suggestionController.text = alimento.descricao;
                            weightController.text = peso.toInt().toString();
                            caloriesController.text = energiaKcal
                                .toInt()
                                .toString();
                            proteinController.text = protein.toStringAsFixed(1);
                            lipidsController.text = lipids.toStringAsFixed(1);
                            carbsController.text = carbs.toStringAsFixed(1);
                          });
                        }
                      },
                      title: "Buscar na Tabela TACO",
                      titleColor: Colors.white,
                      titleSize: 12,
                      buttonColor: MyColors.myPrimary,
                      buttonEdgeInsets: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    CustomInputField(
                      controller: suggestionController,
                      hintText: 'Ex: Frango grelhado',
                      labelText: 'Nome da Sugestão',
                      maxLength: 60,
                    ),
                    const SizedBox(height: 12),
                    CustomInputField(
                      controller: weightController,
                      hintText: 'Ex: 150',
                      labelText: 'Peso (g)',
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                    ),
                    const SizedBox(height: 12),
                    CustomInputField(
                      controller: caloriesController,
                      hintText: 'Ex: 90',
                      labelText: 'Calorias',
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 12),
                    CustomInputField(
                      controller: proteinController,
                      hintText: 'Ex: 10,5',
                      labelText: 'Proteína (g)',
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 12),
                    CustomInputField(
                      controller: lipidsController,
                      hintText: 'Ex: 5,2',
                      labelText: 'Lipídios (g)',
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 12),
                    CustomInputField(
                      controller: carbsController,
                      hintText: 'Ex: 15,8',
                      labelText: 'Carboidratos (g)',
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: () {
                          if (suggestionController.text.isEmpty) {
                            return;
                          }

                          int weight = int.tryParse(weightController.text) ?? 0;
                          int calories =
                              int.tryParse(caloriesController.text) ?? 0;
                          double protein =
                              double.tryParse(
                                proteinController.text.replaceAll(',', '.'),
                              ) ??
                              0;
                          double lipids =
                              double.tryParse(
                                lipidsController.text.replaceAll(',', '.'),
                              ) ??
                              0;
                          double carbs =
                              double.tryParse(
                                carbsController.text.replaceAll(',', '.'),
                              ) ??
                              0;

                          SuggestionItem suggestion = SuggestionItem(
                            foodName: suggestionController.text,
                            weight: weight,
                            calories: calories,
                            protein: protein,
                            lipids: lipids,
                            carbs: carbs,
                          );

                          setDialogState(() {
                            item.suggestions.add(suggestion);
                            onAddSuggestion(suggestion);
                          });

                          suggestionController.clear();
                          weightController.clear();
                          caloriesController.clear();
                          proteinController.clear();
                          lipidsController.clear();
                          carbsController.clear();
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
