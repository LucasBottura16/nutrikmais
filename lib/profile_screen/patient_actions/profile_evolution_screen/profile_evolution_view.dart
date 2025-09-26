import 'package:flutter/material.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';

class ProfileEvolutionView extends StatefulWidget {
  const ProfileEvolutionView({super.key});

  @override
  State<ProfileEvolutionView> createState() => _ProfileEvolutionViewState();
}

class _ProfileEvolutionViewState extends State<ProfileEvolutionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Evolução do Paciente",
        backgroundColor: MyColors.myPrimary,
      ),
      body: const Center(child: Text("Tela de Evolução do Paciente")),
    );
  }
}
