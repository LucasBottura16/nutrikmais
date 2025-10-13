import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_consultations_screen/profile_consultations_service.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:nutrikmais/utils/customs_components/custom_loading_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class ProfileConsultationsView extends StatefulWidget {
  const ProfileConsultationsView({super.key});

  @override
  State<ProfileConsultationsView> createState() =>
      _ProfileConsultationsViewState();
}

class _ProfileConsultationsViewState extends State<ProfileConsultationsView> {
  final _controllerStream = StreamController<QuerySnapshot>.broadcast();

  String? _nutritionistUid;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Future<void> _addAvailabilityDay() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    String date = DateFormat("dd/MM/yyyy").format(_selectedDay);

    if (pickedTime != null && _nutritionistUid != null) {
      final hourStr = pickedTime.hour.toString().padLeft(2, '0');
      final minuteStr = pickedTime.minute.toString().padLeft(2, '0');
      final time = '$hourStr:$minuteStr';

      try {
        await ConsultationService().addAvailability(
          nutritionistUid: _nutritionistUid!,
          date: date,
          time: time,
        );
        ConsultationService.addListenerAvailability(
          _controllerStream,
          _nutritionistUid!,
          DateFormat("dd/MM/yyyy").format(_selectedDay),
        );
        _showSnackBar('Horário adicionado com sucesso!');
      } catch (e) {
        _showSnackBar(e.toString(), isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : MyColors.myPrimary,
      ),
    );
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    _nutritionistUid = prefs.getString('uidLogged');

    if (_nutritionistUid != null) {
      ConsultationService.addListenerAvailability(
        _controllerStream,
        _nutritionistUid!,
        DateFormat("dd/MM/yyyy").format(_selectedDay),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Agenda de Consultas",
        backgroundColor: MyColors.myPrimary,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: _calendarFormat,
            locale: 'pt_BR',
            // eventLoader: _getAvailabilitysForDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;

                ConsultationService.addListenerAvailability(
                  _controllerStream,
                  _nutritionistUid!,
                  DateFormat("dd/MM/yyyy").format(_selectedDay),
                );
              });
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
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder(
              stream: _controllerStream.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return CustomLoadingData(
                      nameData: "Disponibilidades cadastradas",
                      loadingColor: Colors.white,
                      nameDataColor: Colors.white,
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return const Text("Erro ao carregar");
                    }

                    QuerySnapshot<Object?>? querySnapshot = snapshot.data;

                    debugPrint(
                      'Número de documentos: ${querySnapshot?.docs.length}',
                    );

                    if (querySnapshot!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "Nenhuma disponibilidade encontrada!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: MyColors.myPrimary,
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (context, index) {
                          var doc = querySnapshot.docs[index];
                          String date = doc['date'] ?? '';
                          String time = doc['time'] ?? '';
                          bool isScheduled = doc['isScheduled'] ?? false;

                          return Card(
                            color: isScheduled
                                ? Colors.grey[300]
                                : MyColors.myPrimary,
                            child: ListTile(
                              title: Text(
                                'Horário: $time',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isScheduled
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                'Data: $date',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isScheduled
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  if (!mounted) return;

                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Confirmar remoção'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Deseja realmente remover a disponibilidade em $date às $time?'),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text('Remover', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm != true) return;

                                  try {
                                    await ConsultationService().removeAvailability(
                                      nutritionistUid: _nutritionistUid!,
                                      date: date,
                                      time: time,
                                      isScheduled: isScheduled,
                                    );
                                    _showSnackBar('Disponibilidade removida com sucesso!');
                                  } catch (e) {
                                    _showSnackBar(e.toString(), isError: true);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAvailabilityDay,
        tooltip: 'Adicionar Horário',
        child: const Icon(Icons.add),
      ),
    );
  }
}
