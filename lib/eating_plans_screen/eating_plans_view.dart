import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/eating_plans_screen/eating_plans_service.dart';
import 'package:nutrikmais/eating_plans_screen/models/eating_plans_model.dart';
import 'package:nutrikmais/globals/customs/Widgets/select_patient_modal.dart';
import 'package:nutrikmais/globals/configs/route_generator.dart';
import 'package:nutrikmais/globals/customs/Widgets/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs/components/custom_button.dart';
import 'package:nutrikmais/globals/customs/components/custom_loading_data.dart';
import 'package:nutrikmais/globals/customs/Widgets/my_drawer.dart';
import 'package:nutrikmais/globals/hooks/use_user_type.dart';

class EatingPlansView extends StatefulWidget {
  const EatingPlansView({super.key});

  @override
  State<EatingPlansView> createState() => _EatingPlansViewState();
}

class _EatingPlansViewState extends State<EatingPlansView> {
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
    _subscription = EatingPlansService.addListenerEatingPlans(
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
        title: "Planos Alimentares",
        backgroundColor: MyColors.myPrimary,
      ),
      drawer: MyDrawer(screen: "eating_plans_screen"),
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
                          "Planos Alimentares",
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
                                        });
                                        _subscription =
                                            EatingPlansService.addListenerEatingPlans(
                                              _controllerStream,
                                              typeUser: _typeUser,
                                            );
                                      } else {
                                        final doc = await FirebaseFirestore
                                            .instance
                                            .collection('EatingPlans')
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
                                            EatingPlansService.addListenerEatingPlans(
                                              _controllerStream,
                                              typeUser: _typeUser,
                                              uidAccount: selectedUid,
                                            );
                                      }
                                    },
                                    icon: const Icon(Icons.filter_alt_outlined),
                                  ),
                                  if (_selectedPatientName != null &&
                                      _selectedPatientName!.isNotEmpty)
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
                                nameData: "Planos Alimentares",
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
                                    "Nenhum plano alimentar encontrado!",
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
                                  List<DocumentSnapshot> eatingPlans =
                                      querySnapshot.docs.toList();
                                  DocumentSnapshot documentSnapshot =
                                      eatingPlans[index];

                                  DBEatingPlans myEatingPlan =
                                      DBEatingPlans.fromDocumentSnapshotEatingPlans(
                                        documentSnapshot,
                                      );

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteGenerator.eatingPlanDetailsScreen,
                                        arguments: myEatingPlan,
                                      );
                                    },
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Excluir Plano Alimentar',
                                            ),
                                            content: const Text(
                                              'Tem certeza que deseja excluir este plano alimentar?',
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
                                                  await EatingPlansService.deleteEatingPlan(
                                                    myEatingPlan.uidEatingPlans,
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
                                                  myEatingPlan.patientName ??
                                                      '',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Atualizado em: ${myEatingPlan.eatingPlansUpdatedAt}',
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
                            RouteGenerator.addEatingPlansScreen,
                          );
                        },
                        title: "ADICIONAR PLANO ALIMENTAR",
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
