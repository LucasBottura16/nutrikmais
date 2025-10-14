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
    // Mostrar modal para escolher único horário ou recorrente
    if (!mounted) return;
    final choice = await showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Horário'),
          content: const Text(
            'Deseja adicionar um único horário ou um intervalo recorrente?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop('single'),
              child: const Text('Único'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop('recurring'),
              child: const Text('Recorrente'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );

    if (choice == null) return;

    final date = DateFormat("dd/MM/yyyy").format(_selectedDay);

    if (choice == 'single') {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

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
      return;
    }

    // Escolheu recorrente
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    final intervalController = TextEditingController(text: '15');

    final confirmed = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Adicionar Recorrência'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      startTime == null
                          ? 'Escolher hora inicial'
                          : 'Início: ${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) setState(() => startTime = picked);
                    },
                  ),
                  ListTile(
                    title: Text(
                      endTime == null
                          ? 'Escolher hora final'
                          : 'Fim: ${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) setState(() => endTime = picked);
                    },
                  ),
                  TextField(
                    controller: intervalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Intervalo (minutos)',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed != true) return;

    if (startTime == null || endTime == null) {
      _showSnackBar('Selecione hora inicial e final.', isError: true);
      return;
    }

    final intervalMinutes = int.tryParse(intervalController.text) ?? 0;
    if (intervalMinutes <= 0) {
      _showSnackBar('Intervalo inválido.', isError: true);
      return;
    }

    DateTime start = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
      startTime!.hour,
      startTime!.minute,
    );
    DateTime end = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
      endTime!.hour,
      endTime!.minute,
    );

    if (!end.isAfter(start)) {
      _showSnackBar(
        'Hora final precisa ser maior que a inicial.',
        isError: true,
      );
      return;
    }

    // Gerar horários em loop
    List<String> added = [];
    List<String> failed = [];

    DateTime cursor = start;
    while (!cursor.isAfter(end)) {
      final hourStr = cursor.hour.toString().padLeft(2, '0');
      final minuteStr = cursor.minute.toString().padLeft(2, '0');
      final time = '$hourStr:$minuteStr';

      try {
        await ConsultationService().addAvailability(
          nutritionistUid: _nutritionistUid!,
          date: date,
          time: time,
        );
        added.add(time);
      } catch (e) {
        failed.add('$time: ${e.toString()}');
      }

      cursor = cursor.add(Duration(minutes: intervalMinutes));
      if (intervalMinutes <= 0) break;
    }

    ConsultationService.addListenerAvailability(
      _controllerStream,
      _nutritionistUid!,
      DateFormat("dd/MM/yyyy").format(_selectedDay),
    );

    if (added.isNotEmpty) {
      _showSnackBar('Horários adicionados: ${added.join(', ')}');
    }
    if (failed.isNotEmpty) {
      _showSnackBar('Falhas: ${failed.join('; ')}', isError: true);
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
      body: SafeArea(
        child: Column(
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
                                          title: const Text(
                                            'Confirmar remoção',
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Deseja realmente remover a disponibilidade em $date às $time?',
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(
                                                context,
                                              ).pop(false),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(
                                                context,
                                              ).pop(true),
                                              child: const Text(
                                                'Remover',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirm != true) return;

                                    try {
                                      await ConsultationService()
                                          .removeAvailability(
                                            nutritionistUid: _nutritionistUid!,
                                            date: date,
                                            time: time,
                                            isScheduled: isScheduled,
                                          );
                                      _showSnackBar(
                                        'Disponibilidade removida com sucesso!',
                                      );
                                    } catch (e) {
                                      _showSnackBar(
                                        e.toString(),
                                        isError: true,
                                      );
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAvailabilityDay,
        tooltip: 'Adicionar Horário',
        child: const Icon(Icons.add),
      ),
    );
  }
}
