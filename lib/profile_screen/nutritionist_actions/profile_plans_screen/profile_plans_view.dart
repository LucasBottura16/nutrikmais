import 'package:flutter/material.dart';
import 'package:nutrikmais/globals/configs/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';

class ProfilePlansView extends StatefulWidget {
  const ProfilePlansView({super.key});

  @override
  State<ProfilePlansView> createState() => _ProfilePlansViewState();
}

class _ProfilePlansViewState extends State<ProfilePlansView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Planos",
        backgroundColor: MyColors.myPrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Meus Planos',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Aqui você pode adicionar a lista de planos
              Center(
                child: Text(
                  'Nenhum plano disponível no momento.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
