import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrikmais/profile_screen/nutritionist/profile_consultations_screen/profile_consultations_service.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class ProfileConsultationsView extends StatefulWidget {
  const ProfileConsultationsView({super.key});

  @override
  State<ProfileConsultationsView> createState() =>
      _ProfileConsultationsViewState();
}

class _ProfileConsultationsViewState extends State<ProfileConsultationsView> {
  final ConsultationService _consultationService = ConsultationService();
  StreamSubscription? _slotsSubscription;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  String? _nutritionistUid;
  bool _isLoading = true;

  List<Map<String, dynamic>> _allSlots = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _slotsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _nutritionistUid = prefs.getString('uidLogged');

      if (_nutritionistUid == null || _nutritionistUid!.isEmpty) {
        throw Exception("UID do nutricionista não encontrado.");
      }

      _setupSlotsStream();
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
      setState(() => _isLoading = false);
    }
  }

  void _setupSlotsStream() {
    if (_nutritionistUid == null) return;

    _slotsSubscription?.cancel();
    _slotsSubscription = _consultationService
        .getAvailableSlotsStream(_nutritionistUid!)
        .listen((slots) {
          setState(() {
            _allSlots = slots;
            _isLoading = false;
          });
        });
  }

  List<Map<String, dynamic>> _getSlotsForDay(DateTime day) {
    return _allSlots.where((slot) => isSameDay(slot['slotTime'], day)).toList();
  }

  Future<void> _addSlotForSelectedDay() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && _nutritionistUid != null) {
      final newSlotTime = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      try {
        await _consultationService.addAvailableSlot(
          nutritionistUid: _nutritionistUid!,
          slotTime: newSlotTime,
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

  @override
  Widget build(BuildContext context) {
    final selectedDaySlots = _getSlotsForDay(_selectedDay)
      ..sort(
        (a, b) =>
            (a['slotTime'] as DateTime).compareTo(b['slotTime'] as DateTime),
      );

    return Scaffold(
      appBar: CustomAppBar(
        title: "Agenda de Consultas",
        backgroundColor: MyColors.myPrimary,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: MyColors.myPrimary),
                  SizedBox(height: 16),
                  Text(
                    'Carregando horários...',
                    style: TextStyle(fontSize: 16, color: MyColors.myPrimary),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  calendarFormat: _calendarFormat,
                  locale: 'pt_BR',
                  eventLoader: _getSlotsForDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
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
                      color: const Color.fromARGB(
                        125,
                        72,
                        178,
                        128,
                      ).withValues(),
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
                  child: selectedDaySlots.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhum horário disponível para este dia.',
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: selectedDaySlots.length,
                          itemBuilder: (context, index) {
                            final slot = selectedDaySlots[index];
                            final isScheduled = slot['isScheduled'] as bool;
                            final slotTime = slot['slotTime'] as DateTime;
                            return Card(
                              color: isScheduled ? MyColors.myPrimary : null,
                              child: ListTile(
                                title: Text(
                                  'Horário: ${DateFormat('HH:mm').format(slotTime)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isScheduled
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: isScheduled
                                        ? Colors.white
                                        : Colors.red,
                                  ),
                                  onPressed: isScheduled
                                      ? () {
                                          _showSnackBar(
                                            'Horario agendado, não pode ser removido.',
                                            isError: true,
                                          );
                                        }
                                      : () async {
                                          try {
                                            await _consultationService
                                                .removeAvailableSlot(
                                                  nutritionistUid:
                                                      _nutritionistUid!,
                                                  slotTime: slotTime,
                                                );
                                            _showSnackBar(
                                              'Horário removido com sucesso!',
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
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSlotForSelectedDay,
        tooltip: 'Adicionar Horário',
        child: const Icon(Icons.add),
      ),
    );
  }
}
