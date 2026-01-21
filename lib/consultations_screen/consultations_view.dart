import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrikmais/consultations_screen/consultations_services.dart';
import 'package:nutrikmais/consultations_screen/models/consultations_model.dart';
import 'package:nutrikmais/consultations_screen/consultation_detail_dialog.dart';
import 'package:nutrikmais/route_generator.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:nutrikmais/utils/customs_components/custom_button.dart';
import 'package:nutrikmais/utils/customs_components/custom_loading_data.dart';
import 'package:nutrikmais/utils/my_drawer.dart';
import 'package:table_calendar/table_calendar.dart';

class ConsultationsView extends StatefulWidget {
  const ConsultationsView({super.key});

  @override
  State<ConsultationsView> createState() => _ConsultationsViewState();
}

class _ConsultationsViewState extends State<ConsultationsView> {
  late StreamController<QuerySnapshot> _controllerStream;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _controllerStream = StreamController<QuerySnapshot>.broadcast();
    ConsultationsServices.addListenerConsultations(
      _controllerStream,
      DateFormat('dd/MM/yyyy').format(_selectedDay),
    );
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
        title: "Consultas",
        backgroundColor: MyColors.myPrimary,
      ),
      drawer: MyDrawer(screen: "consultations_screen"),
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              calendarFormat: _calendarFormat,
              locale: 'pt_BR',
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                ConsultationsServices.addListenerConsultations(
                  _controllerStream,
                  DateFormat('dd/MM/yyyy').format(_selectedDay),
                ).ignore();
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              headerStyle: const HeaderStyle(formatButtonShowsNext: false),
              calendarStyle: CalendarStyle(
                weekendTextStyle: const TextStyle(color: Colors.red),
                markerDecoration: const BoxDecoration(
                  color: MyColors.myPrimary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: const Color.fromARGB(125, 72, 178, 128).withValues(),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: MyColors.myPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.9,
              height: 50,
              child: CustomButton(
                title: "Adicionar Horário",
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RouteGenerator.addConsultationsScreen,
                    arguments: DateFormat("dd/MM/yyyy").format(_selectedDay),
                  );
                },
                buttonColor: MyColors.myPrimary,
                titleColor: Colors.white,
                icon: Icons.add,
                iconColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MyColors.myPrimary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Minhas Consultas",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Ver todos",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: _controllerStream.stream,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return CustomLoadingData(
                                nameData: "Consultas",
                                loadingColor: Colors.white,
                                nameDataColor: Colors.white,
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
                                    "Nenhuma consulta encontrada!",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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

                                  DBConsultationsModel myConsulation =
                                      DBConsultationsModel.fromDocumentSnapshot(
                                        documentSnapshot,
                                      );
                                  return GestureDetector(
                                    onTap: () {
                                      showConsultationDetailDialog(
                                        context,
                                        myConsulation,
                                        documentSnapshot.id,
                                      );
                                    },
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  myConsulation.patient!,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Serviço: ${myConsulation.serviceName!}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Text(
                                                  "Local: ${myConsulation.place!}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  myConsulation.status!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Text(
                                                  myConsulation
                                                      .timeConsultation!,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
