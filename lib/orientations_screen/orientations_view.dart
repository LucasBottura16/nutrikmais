import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/orientations_screen/models/orientations_model.dart';
import 'package:nutrikmais/orientations_screen/orientations_service.dart';
import 'package:nutrikmais/orientations_screen/patient_selector_modal.dart';
import 'package:nutrikmais/route_generator.dart';
import 'package:nutrikmais/globals/configs/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs_components/custom_button.dart';
import 'package:nutrikmais/globals/customs_components/custom_loading_data.dart';
import 'package:nutrikmais/globals/configs/my_drawer.dart';
import 'package:nutrikmais/globals/hooks/use_user_type.dart';

class OrientationsView extends StatefulWidget {
  const OrientationsView({super.key});

  @override
  State<OrientationsView> createState() => _OrientationsViewState();
}

class _OrientationsViewState extends State<OrientationsView> {
  late StreamController<QuerySnapshot> _controllerStream;
  final bool _isLoading = false;
  StreamSubscription<QuerySnapshot>? _subscription;
  String? _selectedPatientName;
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
    _subscription = OrientationsService.addListenerOrientations(
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
        title: "Orientações",
        backgroundColor: MyColors.myPrimary,
      ),
      drawer: MyDrawer(screen: "orientations_screen"),
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
                    Text(
                      "Orientações",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _typeUser == "patient"
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              CustomButton(
                                onPressed: () async {
                                  final selectedUid =
                                      await showPatientSelectorDialog(context);
                                  if (selectedUid == null) return;

                                  _subscription?.cancel();
                                  if (selectedUid.isEmpty) {
                                    setState(() {
                                      _selectedPatientName = null;
                                    });
                                    _subscription =
                                        OrientationsService.addListenerOrientations(
                                          _controllerStream,
                                          typeUser: _typeUser,
                                        );
                                  } else {
                                    final doc = await FirebaseFirestore.instance
                                        .collection('Orientations')
                                        .where(
                                          'uidAccount',
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
                                    });

                                    _subscription =
                                        OrientationsService.addListenerOrientations(
                                          _controllerStream,
                                          typeUser: _typeUser,
                                          uidAccount: selectedUid,
                                        );
                                  }
                                },
                                title:
                                    _selectedPatientName != null &&
                                        _selectedPatientName!.isNotEmpty
                                    ? _selectedPatientName!
                                    : "Paciente",
                                titleColor: MyColors.myPrimary,
                                buttonColor: Colors.white,
                                buttonEdgeInsets: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 15,
                                ),
                                borderColor: MyColors.myPrimary,
                                borderWidth: 1,
                                showBorder: true,
                              ),

                              const SizedBox(height: 10),
                              Divider(color: Colors.grey.shade400),
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
                              return CustomLoadingData(nameData: "Orientações");
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
                                    "Nenhuma orientação encontrada!",
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
                                  List<DocumentSnapshot> orientations =
                                      querySnapshot.docs.toList();
                                  DocumentSnapshot documentSnapshot =
                                      orientations[index];

                                  DBOrientations myOrientation =
                                      DBOrientations.fromDocumentSnapshotOrientations(
                                        documentSnapshot,
                                      );

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteGenerator.orientationDetailsScreen,
                                        arguments: myOrientation,
                                      );
                                    },
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Excluir Orientação',
                                            ),
                                            content: const Text(
                                              'Tem certeza que deseja excluir esta orientação?',
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
                                                  await OrientationsService.deleteOrientation(
                                                    myOrientation
                                                        .uidOrientations,
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
                                                  myOrientation.patientName ??
                                                      '',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Atualizado em: ${myOrientation.orientationsUpdatedAt}',
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
                          Navigator.pushNamed(
                            context,
                            RouteGenerator.addOrientationsScreen,
                          );
                        },
                        title: "ADICIONAR ORIENTAÇÃO",
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
