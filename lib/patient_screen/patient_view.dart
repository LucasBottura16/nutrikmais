import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/patient_screen/components/modal_patient_view.dart';
import 'package:nutrikmais/patient_screen/models/patient_model.dart';
import 'package:nutrikmais/patient_screen/patient_service.dart';
import 'package:nutrikmais/globals/configs/route_generator.dart';
import 'package:nutrikmais/globals/customs/Widgets/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs/components/custom_button.dart';
import 'package:nutrikmais/globals/customs/components/custom_loading_data.dart';
import 'package:nutrikmais/globals/customs/Widgets/my_drawer.dart';
import 'package:nutrikmais/globals/customs/Widgets/select_patient_modal.dart';
import 'package:nutrikmais/utils/age_utils.dart';

class PatientView extends StatefulWidget {
  const PatientView({super.key});

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  late StreamController<QuerySnapshot> _controllerStream;

  final bool _isLoading = false;
  String _filterPatientUid = ''; // State para filtro de paciente

  _modalPatient(patient) {
    showDialog(
      context: context,
      builder: (context) {
        return ModalPatientView(patient: patient);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controllerStream = StreamController<QuerySnapshot>.broadcast();
    PatientService.addListenerPatient(_controllerStream);
  }

  @override
  void dispose() {
    if (!_controllerStream.isClosed) {
      _controllerStream.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Pacientes",
        backgroundColor: MyColors.myPrimary,
      ),
      drawer: const MyDrawer(screen: "patient_screen"),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pacientes",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Stack(
                          children: [
                            IconButton(
                              onPressed: () async {
                                final selectedUid = await selectPatientModal(
                                  context,
                                  showAllPatients: true,
                                );
                                if (selectedUid != null) {
                                  setState(() {
                                    _filterPatientUid = selectedUid;
                                  });
                                }
                              },
                              icon: const Icon(Icons.filter_alt_outlined),
                            ),
                            if (_filterPatientUid.isNotEmpty)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: MyColors.myPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: StreamBuilder(
                        stream: _controllerStream.stream,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return CustomLoadingData(nameData: "Pacientes");
                            case ConnectionState.active:
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return const Text("Erro ao carregar");
                              }

                              QuerySnapshot<Object?>? querySnapshot =
                                  snapshot.data;

                              if (querySnapshot!.docs.isEmpty) {
                                return const Center(
                                  child: Text(
                                    "Nenhum Paciente encontrado!",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }

                              // Filtrar pacientes se um filtro está ativo
                              List<DocumentSnapshot> filteredDocs =
                                  querySnapshot.docs;
                              if (_filterPatientUid.isNotEmpty) {
                                filteredDocs = querySnapshot.docs.where((doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  final uidAccount = data['uidAccount'] ?? '';
                                  return uidAccount == _filterPatientUid;
                                }).toList();
                              }

                              if (filteredDocs.isEmpty) {
                                return const Center(
                                  child: Text(
                                    "Nenhum paciente corresponde ao filtro!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                itemCount: filteredDocs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot documentSnapshot =
                                      filteredDocs[index];

                                  DBPatientModel myPatient =
                                      DBPatientModel.fromDocumentSnapshotPatients(
                                        documentSnapshot,
                                      );

                                  return GestureDetector(
                                    onTap: () {
                                      _modalPatient(myPatient);
                                    },
                                    child: Card(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: myPatient.photo == "null"
                                                    ? Image.asset(
                                                        "images/Logo.png",
                                                        color:
                                                            MyColors.myPrimary,
                                                        width: 70,
                                                        height: 70,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        myPatient.photo,
                                                        width: 70,
                                                        height: 70,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                              const SizedBox(width: 5),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    myPatient.patient,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: MyColors.myPrimary,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "conta: ${myPatient.stateAccount}",
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        "Idade: ${AgeUtils.calculateAgeFromBirthDate(myPatient.birthDate)} anos",
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "Última Consulta: ${myPatient.lastschedule}",
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
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
                    Navigator.pushNamed(
                      context,
                      RouteGenerator.addPatientScreen,
                    );
                  },
                  title: "ADICIONAR PACIENTE",
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
      ),
    );
  }
}
