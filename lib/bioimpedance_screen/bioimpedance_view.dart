import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/bioimpedance_screen/bioimpedance_service.dart';
import 'package:nutrikmais/bioimpedance_screen/models/bioimpedance_model.dart';
import 'package:nutrikmais/globals/configs/route_generator.dart';
import 'package:nutrikmais/globals/customs/Widgets/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs/Widgets/select_patient_modal.dart';
import 'package:nutrikmais/globals/customs/components/custom_button.dart';
import 'package:nutrikmais/globals/customs/components/custom_loading_data.dart';
import 'package:nutrikmais/globals/customs/Widgets/my_drawer.dart';
import 'package:nutrikmais/globals/hooks/use_user_type.dart';

class BioimpedanceView extends StatefulWidget {
  const BioimpedanceView({super.key});

  @override
  State<BioimpedanceView> createState() => _BioimpedanceViewState();
}

class _BioimpedanceViewState extends State<BioimpedanceView> {
  late StreamController<QuerySnapshot> _controllerStream;
  final bool _isLoading = false;
  StreamSubscription<QuerySnapshot>? _subscription;
  String? _selectedPatientName;
  String? _selectedPatientUid;

  String _typeUser = "";
  String _uidAccount = "";

  _verifyAccount() async {
    final userPrefs = await useUserPreferences();
    setState(() {
      _typeUser = userPrefs.typeUser;
      _uidAccount = userPrefs.uidAccount;
    });
  }

  @override
  void initState() {
    super.initState();
    _controllerStream = StreamController<QuerySnapshot>.broadcast();
    _initializeData();
  }

  void _initializeData() async {
    await _verifyAccount();
    _subscription = BioimpedanceService.addListenerBioimpedances(
      _controllerStream,
      typeUser: _typeUser,
      uidAccount: _uidAccount,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    if (!_controllerStream.isClosed) {
      _controllerStream.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Bioimpedância",
        backgroundColor: MyColors.myPrimary,
      ),
      drawer: MyDrawer(screen: "bioimpedance_screen"),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "bioimpedâncias",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _typeUser == "patient"
                            ? const SizedBox.shrink()
                            : Stack(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final selectedUid =
                                          await selectPatientModal(context);
                                      if (selectedUid == null) return;

                                      _subscription?.cancel();
                                      if (selectedUid.isEmpty) {
                                        setState(() {
                                          _selectedPatientName = null;
                                          _selectedPatientUid = null;
                                        });
                                        _subscription =
                                            BioimpedanceService.addListenerBioimpedances(
                                              _controllerStream,
                                              typeUser: _typeUser,
                                            );
                                      } else {
                                        final doc = await FirebaseFirestore
                                            .instance
                                            .collection('Bioimpedance')
                                            .where(
                                              'uidPatient',
                                              isEqualTo: selectedUid,
                                            )
                                            .limit(1)
                                            .get();
                                        final patientName = doc.docs.isNotEmpty
                                            ? (doc.docs.first
                                                          .data()['patientName'] ??
                                                      doc.docs.first
                                                          .data()['patient'] ??
                                                      '')
                                                  .toString()
                                            : '';

                                        setState(() {
                                          _selectedPatientName = patientName;
                                          _selectedPatientUid = selectedUid;
                                        });

                                        _subscription =
                                            BioimpedanceService.addListenerBioimpedances(
                                              _controllerStream,
                                              uidAccount: selectedUid,
                                              typeUser: _typeUser,
                                            );
                                      }
                                    },
                                    icon: const Icon(Icons.filter_alt_outlined),
                                  ),
                                  if (_selectedPatientUid != null &&
                                      _selectedPatientUid!.isNotEmpty)
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
                    const SizedBox(height: 10),
                    Divider(color: Colors.grey.shade400),

                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: StreamBuilder(
                        stream: _controllerStream.stream,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return CustomLoadingData(
                                nameData: "Bioimpedâncias",
                              );
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
                                    "Nenhuma bioimpedância encontrada!",
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
                                  List<DocumentSnapshot> bioimpedances =
                                      querySnapshot.docs.toList();
                                  DocumentSnapshot documentSnapshot =
                                      bioimpedances[index];

                                  DBBioimpedance myBioimpedance =
                                      DBBioimpedance.fromDocumentSnapshotBioimpedance(
                                        documentSnapshot,
                                      );

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteGenerator
                                            .bioimpedanceDetailsScreen,
                                        arguments: myBioimpedance,
                                      );
                                    },
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Excluir Bioimpedância',
                                            ),
                                            content: const Text(
                                              'Tem certeza que deseja excluir esta bioimpedância?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await BioimpedanceService.deleteBioimpedance(
                                                    myBioimpedance
                                                        .uidBioimpedance,
                                                  );
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Excluir'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Card(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  myBioimpedance.patientName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Atualizado em: ${myBioimpedance.bioimpedanceUpdatedAt}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
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
            _typeUser == "patient"
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            RouteGenerator.addBioimpedanceScreen,
                          );

                          // Reassina o listener para garantir atualização em tempo real
                          _subscription?.cancel();
                          _subscription =
                              BioimpedanceService.addListenerBioimpedances(
                                _controllerStream,
                                uidAccount: _selectedPatientUid,
                                typeUser: _typeUser,
                              );
                        },
                        title: "ADICIONAR BIOIMPEDÂNCIA",
                        titleColor: Colors.white,
                        titleSize: 16,
                        buttonEdgeInsets: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
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
