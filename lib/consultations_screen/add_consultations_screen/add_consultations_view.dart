import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrikmais/consultations_screen/add_consultations_screen/add_consultations_service.dart';
import 'package:nutrikmais/consultations_screen/add_consultations_screen/patient_selector_modal.dart';
import 'package:nutrikmais/globals/customs/Widgets/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs/components/custom_button.dart';
import 'package:nutrikmais/globals/customs/components/custom_dropdown.dart';
import 'package:nutrikmais/globals/customs/components/custom_input_field.dart';

class AddConsultationsView extends StatefulWidget {
  const AddConsultationsView({super.key, this.date});

  final String? date;

  @override
  State<AddConsultationsView> createState() => _AddConsultationsViewState();
}

class _AddConsultationsViewState extends State<AddConsultationsView> {
  DateTime? selectedDateEnd;
  QueryDocumentSnapshot? _selectedPatient;

  TextEditingController _placeController = TextEditingController();

  bool _isLoading = false;

  String? _selectedHour;
  List<String> _availableTimes = [];

  final List<String> _serviceTypes = [];
  String? _selectedServiceType;
  List<Map<String, dynamic>> _servicesWithPrices = [];
  Map<String, dynamic>? _selectedServiceMap;

  String? _selectedConsultationType;

  Future<void> _loadAvailableTimes() async {
    if (selectedDateEnd == null) return;
    final dateStr = DateFormat('dd/MM/yyyy').format(selectedDateEnd!);

    try {
      final times = await AddConsultationsService().getAvailableTimesByDate(
        dateStr,
      );
      setState(() {
        _availableTimes = times;
      });
      setState(() {
        _selectedHour = null;
      });
    } catch (e) {
      debugPrint('Error loading available times: $e');
    }
  }

  Future<void> _selectDateEnd(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateEnd,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDateEnd) {
      setState(() {
        selectedDateEnd = picked;
      });
      _loadAvailableTimes();
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDateEnd = widget.date!.isNotEmpty
        ? DateFormat("dd/MM/yyyy").parse(widget.date!)
        : DateTime.now();
    _loadAvailableTimes();
    AddConsultationsService()
        .getServicesWithPrices()
        .then((services) {
          setState(() {
            _servicesWithPrices = services;
            _serviceTypes.clear();
            _serviceTypes.addAll(
              services.map((s) => s['nameService'] as String).toList(),
            );
          });
        })
        .catchError((e) {
          debugPrint('Erro ao carregar serviços: $e');
        });
  }

  Future<void> _modalPatients() async {
    final selected = await showPatientSelectorDialog(context);
    if (selected != null) {
      setState(() {
        _selectedHour = null;
        _selectedPatient = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Adicionar Consulta",
        backgroundColor: MyColors.myPrimary,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _selectedPatient == null
                        ? CustomButton(
                            onPressed: () {
                              _modalPatients();
                            },
                            title: "Paciente",
                            titleColor: MyColors.myPrimary,
                            titleSize: 16,
                            buttonEdgeInsets: const EdgeInsets.symmetric(
                              vertical: 25,
                            ),
                          )
                        : FutureBuilder<Map<String, dynamic>>(
                            future: Future.value(
                              _selectedPatient!.data() as Map<String, dynamic>,
                            ),
                            builder: (context, snap) {
                              if (!snap.hasData) return const SizedBox();
                              final pdata = snap.data!;
                              return GestureDetector(
                                onTap: () => _modalPatients(),
                                onLongPress: () => {
                                  setState(() {
                                    _selectedPatient = null;
                                  }),
                                },
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child:
                                          pdata['photo'] == 'null' ||
                                              pdata['photo'] == ''
                                          ? Image.asset(
                                              'images/Logo.png',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              color: MyColors.myPrimary,
                                            )
                                          : Image.network(
                                              pdata['photo'],
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    title: Text(
                                      pdata['patient'] ??
                                          pdata['name'] ??
                                          'Sem nome',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: pdata['email'] != null
                                        ? Text(pdata['email'])
                                        : null,
                                    trailing: const Icon(Icons.edit),
                                  ),
                                ),
                              );
                            },
                          ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        CustomButton(
                          onPressed: () {
                            _selectDateEnd(context);
                          },
                          title: "",
                          buttonColor: MyColors.myPrimary,
                          icon: Icons.calendar_month,
                          iconColor: Colors.white,
                          iconSize: 25,
                        ),
                        const SizedBox(width: 10),

                        Text(
                          DateFormat("dd/MM/yyyy").format(selectedDateEnd!),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    CustomDropdown<String>(
                      value: _selectedHour,
                      hintText: 'Escolha um horário disponível',
                      items: _availableTimes,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedHour = newValue;
                        });
                      },
                      labelText: 'HORÁRIOS DISPONÍVEIS',
                    ),
                    const SizedBox(height: 15),
                    CustomDropdown<String>(
                      value: _selectedServiceType,
                      hintText: 'Escolha um tipo de serviço',
                      items: _serviceTypes,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedServiceType = newValue;
                          try {
                            final found = _servicesWithPrices.firstWhere(
                              (s) => s['nameService'] == newValue,
                            );
                            _selectedServiceMap = Map<String, dynamic>.from(
                              found,
                            );
                          } catch (e) {
                            _selectedServiceMap = null;
                          }
                        });
                      },
                      labelText: 'TIPO DO SERVIÇO',
                    ),
                    const SizedBox(height: 15),
                    CustomDropdown<String>(
                      value: _selectedConsultationType,
                      hintText: 'Escolha um tipo de consulta',
                      items: ['Online', 'Presencial'],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedConsultationType = newValue;
                        });
                      },
                      labelText: 'TIPO DA CONSULTA',
                    ),
                    const SizedBox(height: 12),
                    _selectedConsultationType != null
                        ? _selectedConsultationType == 'Presencial'
                              ? CustomInputField(
                                  labelText: 'Local da Consulta',
                                  hintText: 'Digite o local da consulta',
                                  controller: _placeController,
                                  maxLength: 120,
                                )
                              : CustomInputField(
                                  labelText: 'Link da Consulta',
                                  hintText: 'Digite o link da consulta',
                                  controller: _placeController,
                                  maxLength: 200,
                                )
                        : SizedBox(),
                    const SizedBox(height: 12),
                    Text(
                      _selectedServiceMap != null
                          ? 'Valor: ${_selectedServiceMap!['price'].toString()}'
                          : 'Selecione um serviço',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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

                    await AddConsultationsService().createConsultation(
                      context,
                      _selectedPatient!['uidAccount'],
                      _selectedPatient!['patient'],
                      _selectedPatient!['photo'],
                      selectedDateEnd != null
                          ? DateFormat('dd/MM/yyyy').format(selectedDateEnd!)
                          : '',
                      _selectedHour!,
                      _selectedServiceMap!['nameService'] ?? '',
                      _selectedServiceMap!['price']?.toString() ?? '0',
                      _selectedConsultationType ?? '',
                      _placeController.text,
                    );

                    setState(() {
                      _isLoading = true;
                    });
                  },
                  title: "ADICIONAR CONSULTA",
                  titleColor: Colors.white,
                  titleSize: 16,
                  buttonEdgeInsets: const EdgeInsets.symmetric(vertical: 20),
                  buttonColor: MyColors.myPrimary,
                  buttonBorderRadius: 0,
                  loadingColor: MyColors.myPrimary,
                  isLoading: _isLoading,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
