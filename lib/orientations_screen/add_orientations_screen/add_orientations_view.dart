import 'package:flutter/material.dart';
import 'package:nutrikmais/globals/configs/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs_components/custom_select_patient_modal.dart';
import 'package:nutrikmais/orientations_screen/add_orientations_screen/add_orientations_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrikmais/globals/customs_components/custom_button.dart';
import 'package:nutrikmais/globals/customs_components/custom_input_field.dart';

class AddOrientationsView extends StatefulWidget {
  const AddOrientationsView({super.key});

  @override
  State<AddOrientationsView> createState() => _AddOrientationsViewState();
}

class _AddOrientationsViewState extends State<AddOrientationsView> {
  QueryDocumentSnapshot? _selectedConsultation;
  final AddOrientationsService _service = AddOrientationsService();
  final TextEditingController _orientationController = TextEditingController();
  final List<String> _orientations = [];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Adicionar Orientações",
        backgroundColor: MyColors.myPrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
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

                            final selected = await customSelectPatientModal(
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
                                                      color: Colors.grey,
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
                                          color: MyColors.myPrimary.withValues(
                                            alpha: 0.2,
                                          ),
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

                            final selected = await customSelectPatientModal(
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
                                  Text(
                                    "Selecione uma consulta",
                                    style: const TextStyle(
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
                  const SizedBox(height: 12),
                  const Text(
                    'ADICIONAR PRE-PRONTO',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: CustomInputField(
                          controller: _orientationController,
                          hintText: 'Adicione uma orientação',
                          labelText: 'Sem texto',
                        ),
                      ),
                      const SizedBox(width: 8),
                      CustomButton(
                        onPressed: () {
                          final text = _orientationController.text.trim();

                          if (text.isEmpty) return;

                          setState(() {
                            _orientations.add(text);
                            _orientationController.clear();
                          });
                        },
                        title: "",
                        icon: Icons.add,
                        iconColor: Colors.white,
                        buttonColor: MyColors.myPrimary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: _orientations.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('Nenhuma orientação adicionada'),
                            )
                          : ListView.separated(
                              itemCount: _orientations.length,
                              padding: const EdgeInsets.all(8),
                              itemBuilder: (context, index) {
                                final orientation = _orientations[index];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(width: 8),
                                    Expanded(child: Text(orientation)),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _orientations.removeAt(index);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (_, __) => const Divider(),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    await _service.completedRegister(
                      (_selectedConsultation!.data()
                          as Map<String, dynamic>)['uidAccount'],
                      (_selectedConsultation!.data()
                          as Map<String, dynamic>)['patient'],
                      _orientations,
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao salvar orientações: $e')),
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
                title: "SALVAR ORIENTAÇÕES",
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
