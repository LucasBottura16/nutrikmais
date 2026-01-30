import 'package:flutter/material.dart';
import 'package:nutrikmais/globals/customs/Widgets/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';

class EvolutionView extends StatefulWidget {
  const EvolutionView({super.key});

  @override
  State<EvolutionView> createState() => _EvolutionViewState();
}

class _EvolutionViewState extends State<EvolutionView> {
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
