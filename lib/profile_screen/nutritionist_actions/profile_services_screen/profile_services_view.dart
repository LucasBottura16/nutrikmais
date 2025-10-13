import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_services_screen/components/add_services_modal.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_services_screen/models/profile_services_model.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_services_screen/profile_services_service.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:nutrikmais/utils/customs_components/custom_button.dart';
import 'package:nutrikmais/utils/customs_components/custom_loading_data.dart';

class ProfileServicesView extends StatefulWidget {
  const ProfileServicesView({super.key});

  @override
  State<ProfileServicesView> createState() => _ProfileServicesViewState();
}

class _ProfileServicesViewState extends State<ProfileServicesView> {
  final _controllerStream = StreamController<QuerySnapshot>.broadcast();

  _addNewServices() async {
    await AddServiceSheet.show(context);
  }

  @override
  void initState() {
    super.initState();
    ProfileServicesService.addListenerService(_controllerStream);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Serviços",
        backgroundColor: MyColors.myPrimary,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _controllerStream.stream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return CustomLoadingData(nameData: "Serviços");
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Erro ao carregar os dados."),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "Nenhum serviço cadastrado.",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        );
                      }

                      final querySnapshot = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.all(
                          16.0,
                        ), // Padding aplicado aqui
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              querySnapshot.docs[index];
                          DBServiceModel myServices =
                              DBServiceModel.fromDocumentSnapshot(
                                documentSnapshot,
                              );

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        myServices.nameService,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: MyColors.myPrimary,
                                        ),
                                      ),
                                      Text(
                                        myServices.priceService,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      ProfileServicesService().deleteService(
                                        myServices.uidNutritionist,
                                        myServices.uidService,
                                      );
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
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
            CustomButton(
              onPressed: _addNewServices,
              title: "CADASTRAR NOVO SERVIÇO",
              titleColor: Colors.white,
              titleSize: 16,
              buttonEdgeInsets: const EdgeInsets.symmetric(vertical: 20),
              buttonColor: MyColors.myPrimary,
              buttonBorderRadius: 0,
              loadingColor: MyColors.myPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
