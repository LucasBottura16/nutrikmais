import 'package:flutter/material.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';

class ProfileMyNutriView extends StatefulWidget {
  const ProfileMyNutriView({super.key});

  @override
  State<ProfileMyNutriView> createState() => _ProfileMyNutriViewState();
}

class _ProfileMyNutriViewState extends State<ProfileMyNutriView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Informações do Nutricionista',
        backgroundColor: MyColors.myPrimary,
      ),
      body: const Center(child: Text('Tela do Meu Nutricionista')),
    );
  }
}
