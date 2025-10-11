import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrikmais/route_generator.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:nutrikmais/utils/customs_components/custom_button.dart';
import 'package:nutrikmais/utils/my_drawer.dart';
import 'package:table_calendar/table_calendar.dart';

class ConsultationsView extends StatefulWidget {
  const ConsultationsView({super.key});

  @override
  State<ConsultationsView> createState() => _ConsultationsViewState();
}

class _ConsultationsViewState extends State<ConsultationsView> {
  bool _isLoading = true;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Consultas",
        backgroundColor: MyColors.myPrimary,
      ),
      drawer: MyDrawer(screen: "consultations_screen"),
      body: Column(
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
              decoration: BoxDecoration(
                color: MyColors.myPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: false
                  ? const Center(
                      child: Text(
                        'Nenhuma consulta para este dia.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Card(
                          color: MyColors.mySecondary,
                          child: ListTile(
                            title: Text(
                              'Horário: ${DateFormat('HH:mm').format(DateTime.now())}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
