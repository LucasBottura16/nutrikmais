import 'package:flutter/material.dart';
import 'package:nutrikmais/globals/configs/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/bioimpedance_screen/add_bioimpedance_screen/add_bioimpedance_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrikmais/globals/customs_components/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:nutrikmais/globals/customs_components/custom_select_patient_modal.dart';

class AddBioimpedanceView extends StatefulWidget {
  const AddBioimpedanceView({super.key});

  @override
  State<AddBioimpedanceView> createState() => _AddBioimpedanceViewState();
}

class _AddBioimpedanceViewState extends State<AddBioimpedanceView> {
  QueryDocumentSnapshot? _selectedConsultation;
  final AddBioimpedanceService _service = AddBioimpedanceService();
  final List<String> _bioimpedanceImages = [];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Adicionar Bioimpedância",
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
                    'ADICIONAR IMAGENS',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CustomButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      try {
                        final pickedFiles = await picker.pickMultiImage();
                        if (pickedFiles.isNotEmpty) {
                          setState(() {
                            _bioimpedanceImages.addAll(
                              pickedFiles.map((file) => file.path).toList(),
                            );
                          });
                        }
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao selecionar imagens: $e'),
                          ),
                        );
                      }
                    },
                    title: "Selecionar Imagens",
                    titleColor: Colors.white,
                    icon: Icons.add_photo_alternate,
                    iconColor: Colors.white,
                    buttonColor: MyColors.myPrimary,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: _bioimpedanceImages.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('Nenhuma imagem adicionada'),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(8),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                              itemCount: _bioimpedanceImages.length,
                              itemBuilder: (context, index) {
                                final imagePath = _bioimpedanceImages[index];
                                final isNetworkImage =
                                    imagePath.startsWith('http://') ||
                                    imagePath.startsWith('https://');

                                return Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Colors.grey.shade300,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: isNetworkImage
                                            ? Image.network(
                                                imagePath,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return const Center(
                                                        child: Icon(
                                                          Icons.broken_image,
                                                        ),
                                                      );
                                                    },
                                              )
                                            : kIsWeb
                                            ? Image.network(
                                                imagePath,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return const Center(
                                                        child: Icon(
                                                          Icons.broken_image,
                                                        ),
                                                      );
                                                    },
                                              )
                                            : Image.file(
                                                File(imagePath),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return const Center(
                                                        child: Icon(
                                                          Icons.broken_image,
                                                        ),
                                                      );
                                                    },
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _bioimpedanceImages.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
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
                      _bioimpedanceImages,
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao salvar bioimpedância: $e'),
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
                title: "SALVAR BIOIMPEDÂNCIA",
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
