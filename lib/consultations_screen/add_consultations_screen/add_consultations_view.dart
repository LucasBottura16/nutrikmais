import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrikmais/consultations_screen/add_consultations_screen/add_consultations_service.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:nutrikmais/utils/customs_components/custom_button.dart';
import 'package:nutrikmais/utils/customs_components/custom_dropdown.dart';

class AddConsultationsView extends StatefulWidget {
  const AddConsultationsView({super.key, this.date});

  final String? date;

  @override
  State<AddConsultationsView> createState() => _AddConsultationsViewState();
}

class _AddConsultationsViewState extends State<AddConsultationsView> {
  DateTime? selectedDateEnd;

  String? _selectedHour;
  List<String> _availableTimes = [];

  Future<void> _loadAvailableTimes() async {
    if (selectedDateEnd == null) return;
    final dateStr = DateFormat('dd/MM/yyyy').format(selectedDateEnd!);

    try {
      final times = await AddConsultationsService().getAvailableTimesByDate(
        dateStr,
      );
      setState(() {
        _availableTimes = times;
      });
      setState(() {
        _selectedHour = null;
      });
    } catch (e) {
      // ignore or show error
    }
  }

  Future<void> _selectDateEnd(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateEnd,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDateEnd) {
      setState(() {
        selectedDateEnd = picked;
      });
      _loadAvailableTimes();
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDateEnd = widget.date!.isNotEmpty
        ? DateFormat("dd/MM/yyyy").parse(widget.date!)
        : DateTime.now();
    _loadAvailableTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Adicionar Consulta",
        backgroundColor: MyColors.myPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomButton(
                    onPressed: () {
                      _selectDateEnd(context);
                    },
                    title: "",
                    buttonColor: MyColors.myPrimary,
                    icon: Icons.calendar_month,
                    iconColor: Colors.white,
                    iconSize: 25,
                  ),
                  const SizedBox(width: 10),

                  Text(
                    DateFormat("dd/MM/yyyy").format(selectedDateEnd!),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomDropdown<String>(
                value: _selectedHour,
                hintText: 'Escolha um horário disponível',
                items: _availableTimes,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedHour = newValue;
                  });
                },
                labelText: 'HORÁRIOS DISPONÍVEIS',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
