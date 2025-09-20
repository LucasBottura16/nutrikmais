import 'package:flutter/material.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';

class ProfileConsultationsView extends StatefulWidget {
  const ProfileConsultationsView({super.key});

  @override
  State<ProfileConsultationsView> createState() =>
      _ProfileConsultationsViewState();
}

class _ProfileConsultationsViewState extends State<ProfileConsultationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Consultas",
        backgroundColor: MyColors.myPrimary,
      ),
      body: SingleChildScrollView(child: Column(children: [Text("data")])),
    );
  }
}
