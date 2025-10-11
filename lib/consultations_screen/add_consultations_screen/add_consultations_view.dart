import 'package:flutter/material.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';

class AddConsultationsView extends StatefulWidget {
  const AddConsultationsView({super.key});

  @override
  State<AddConsultationsView> createState() => _AddConsultationsViewState();
}

class _AddConsultationsViewState extends State<AddConsultationsView> {
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
            Center(
              child: Text(
                "Consultas",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
