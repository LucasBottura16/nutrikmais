import 'package:flutter/material.dart';
import 'package:nutrikmais/globals/customs/components/custom_input_field.dart';
import 'package:nutrikmais/globals/customs/components/custom_button.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/eating_plans_screen/add_eating_plans_screen/modals/select_taco_food_modal.dart';

/// Modal para adicionar um novo alimento
void showAddFoodDialog({
  required BuildContext context,
  required TextEditingController foodNameController,
  required TextEditingController weightController,
  required TextEditingController caloriesController,
  required Function(
    String foodName,
    int weight,
    int calories,
    double protein,
    double lipids,
    double carbs,
  )
  onAddFood,
}) {
  showDialog(
    context: context,
    builder: (context) {
      // Controllers adicionais para proteína, lipídios e carboidratos
      final TextEditingController proteinController = TextEditingController();
      final TextEditingController lipidsController = TextEditingController();
      final TextEditingController carbsController = TextEditingController();

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Adicionar Alimento'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    onPressed: () async {
                      final alimento = await showSelectTacoFoodDialog(context);

                      if (alimento != null) {
                        // Extrair valores numéricos do alimento
                        double energiaKcal = 0;
                        double peso = 100; // Peso padrão de 100g
                        double protein = 0;
                        double lipids = 0;
                        double carbs = 0;

                        try {
                          // Tentar converter energia (kcal)
                          final energiaStr = alimento.energiaKcal.replaceAll(
                            ',',
                            '.',
                          );
                          energiaKcal = double.tryParse(energiaStr) ?? 0;

                          // Tentar extrair peso da medida caseira (se existir número)
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

                          // Converter proteína
                          final proteinStr = alimento.proteinaG.replaceAll(
                            ',',
                            '.',
                          );
                          protein = double.tryParse(proteinStr) ?? 0;

                          // Converter lipídios
                          final lipidsStr = alimento.lipideosG.replaceAll(
                            ',',
                            '.',
                          );
                          lipids = double.tryParse(lipidsStr) ?? 0;

                          // Converter carboidratos
                          final carbsStr = alimento.carboidratoG.replaceAll(
                            ',',
                            '.',
                          );
                          carbs = double.tryParse(carbsStr) ?? 0;
                        } catch (e) {
                          // Usar valores padrão em caso de erro
                        }

                        setState(() {
                          foodNameController.text = alimento.descricao;
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
                    titleSize: 14,
                    buttonColor: MyColors.myPrimary,
                    buttonEdgeInsets: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: foodNameController,
                    hintText: 'nome do alimento',
                    labelText: 'Alimento',
                    maxLength: 60,
                  ),
                  const SizedBox(height: 12),
                  CustomInputField(
                    controller: weightController,
                    hintText: 'Ex: 150 (g)',
                    labelText: 'Medidas',
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
                ],
              ),
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

                  final protein = double.tryParse(proteinController.text) ?? 0;
                  final lipids = double.tryParse(lipidsController.text) ?? 0;
                  final carbs = double.tryParse(carbsController.text) ?? 0;

                  onAddFood(
                    foodNameController.text,
                    int.parse(weightController.text),
                    int.parse(caloriesController.text),
                    protein,
                    lipids,
                    carbs,
                  );

                  foodNameController.clear();
                  weightController.clear();
                  caloriesController.clear();
                  proteinController.clear();
                  lipidsController.clear();
                  carbsController.clear();

                  Navigator.pop(context);
                },
                child: const Text('Adicionar'),
              ),
            ],
          );
        },
      );
    },
  );
}
