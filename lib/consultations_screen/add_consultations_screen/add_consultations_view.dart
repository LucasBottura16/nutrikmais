import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:nutrikmais/utils/customs_components/custom_button.dart';

class AddConsultationsView extends StatefulWidget {
  const AddConsultationsView({super.key, this.date});

  final String? date;

  @override
  State<AddConsultationsView> createState() => _AddConsultationsViewState();
}

class _AddConsultationsViewState extends State<AddConsultationsView> {
  DateTime? selectedDateEnd;

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
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDateEnd = widget.date!.isNotEmpty
        ? DateFormat("dd/MM/yyyy").parse(widget.date!)
        : DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Adicionar Consulta",
        backgroundColor: MyColors.myPrimary,
      ),
      body: SingleChildScrollView(
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
                ),
                const SizedBox(width: 10),

                Text(
                  DateFormat("dd/MM/yyyy").format(selectedDateEnd!),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
