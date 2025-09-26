import 'package:flutter/material.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';

class ProfileInfosPatientView extends StatefulWidget {
  const ProfileInfosPatientView({super.key});

  @override
  State<ProfileInfosPatientView> createState() =>
      _ProfileInfosPatientViewState();
}

class _ProfileInfosPatientViewState extends State<ProfileInfosPatientView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Informações do Paciente',
        backgroundColor: MyColors.myPrimary,
      ),
      body: const Center(child: Text('Tela de Informações do Paciente')),
    );
  }
}
