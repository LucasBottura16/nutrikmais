import 'package:flutter/material.dart';
import 'package:nutrikmais/profile_screen/patient_actions/profile_my_nutri_screen/profile_my_nutri_service.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:nutrikmais/utils/customs_components/custom_button.dart';

class ProfileMyNutriView extends StatefulWidget {
  const ProfileMyNutriView({super.key});

  @override
  State<ProfileMyNutriView> createState() => _ProfileMyNutriViewState();
}

class _ProfileMyNutriViewState extends State<ProfileMyNutriView> {
  String _nameNutri = "";
  String _crnNutri = "";
  String _phoneNutri = "";

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final nutriInfo = await ProfileMyNutriService.getNutritionistInfo();

    setState(() {
      _nameNutri = nutriInfo['nameNutritionist'];
      _crnNutri = nutriInfo['crn'];
      _phoneNutri = nutriInfo['phone'];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Info. do Nutricionista',
        backgroundColor: MyColors.myPrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informações do Nutricionista',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Nome:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(_nameNutri, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 20),
                        const Text(
                          'CRN:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(_crnNutri, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 20),
                        const Text(
                          'Telefone:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(_phoneNutri, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: () async {
                          ProfileMyNutriService.launchWhatsApp(
                            _phoneNutri,
                            _nameNutri,
                          );
                        },
                        title: "Chamar no WhatsApp",
                        titleColor: Colors.white,
                        titleSize: 16,
                        buttonEdgeInsets: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        buttonColor: MyColors.myPrimary,
                        buttonBorderRadius: 0,
                        isLoading: _isLoading,
                        loadingColor: MyColors.myPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
