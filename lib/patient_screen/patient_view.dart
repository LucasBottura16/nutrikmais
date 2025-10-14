import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/patient_screen/components/modal_patient_view.dart';
import 'package:nutrikmais/patient_screen/models/patient_model.dart';
import 'package:nutrikmais/patient_screen/patient_service.dart';
import 'package:nutrikmais/route_generator.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:nutrikmais/utils/customs_components/custom_button.dart';
import 'package:nutrikmais/utils/customs_components/custom_loading_data.dart';
import 'package:nutrikmais/utils/my_drawer.dart';

class PatientView extends StatefulWidget {
  const PatientView({super.key});

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  final _controllerStream = StreamController<QuerySnapshot>.broadcast();

  final bool _isLoading = false;

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
    PatientService.addListenerPatient(_controllerStream);
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
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_alt_outlined),
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

                              return ListView.builder(
                                itemCount: querySnapshot.docs.length,
                                itemBuilder: (context, index) {
                                  List<DocumentSnapshot> patient = querySnapshot
                                      .docs
                                      .toList();
                                  DocumentSnapshot documentSnapshot =
                                      patient[index];

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
