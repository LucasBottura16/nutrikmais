import 'package:flutter/material.dart';
import 'package:nutrikmais/profile_screen/patient_actions/profile_infos_patient_screen/profile_infos_patient_service.dart';
import 'package:nutrikmais/globals/customs/Widgets/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs/components/custom_button.dart';
import 'package:nutrikmais/globals/customs/components/custom_input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileInfosPatientView extends StatefulWidget {
  const ProfileInfosPatientView({super.key});

  @override
  State<ProfileInfosPatientView> createState() =>
      _ProfileInfosPatientViewState();
}

class _ProfileInfosPatientViewState extends State<ProfileInfosPatientView> {
  final TextEditingController _controllerPhonePatient = TextEditingController();
  final TextEditingController _controllerAddressPatient =
      TextEditingController();

  String _namePatient = "";
  String _cpfPatient = "";
  String _email = "";
  String _age = "";
  String _codePatient = "";
  String _gender = "";
  String _uid = "";

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final name = prefs.getString('patient') ?? '';
    final cpf = prefs.getString('cpf') ?? '';
    final phone = prefs.getString('phone') ?? '';
    final address = prefs.getString('address') ?? '';
    final email = prefs.getString('email') ?? '';
    final age = prefs.getString('age') ?? '';
    final gender = prefs.getString('gender') ?? '';
    final codePatient = prefs.getString('codePatient') ?? '';
    final uidValue = prefs.getString('uidAccount') ?? "";

    setState(() {
      _namePatient = name;
      _cpfPatient = cpf;
      _email = email;
      _age = age;
      _gender = gender;
      _codePatient = codePatient;
      _controllerPhonePatient.text = phone;
      _controllerAddressPatient.text = address;
      _uid = uidValue;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Info. do Paciente',
        backgroundColor: MyColors.myPrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informações do Paciente',
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
                    Text(_namePatient, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    const Text(
                      'CPF:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(_cpfPatient, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    const Text(
                      'Email:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(_email, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    const Text(
                      'Idade:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(_age, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    const Text(
                      'Genêro:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(_gender, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    const Text(
                      'Código do Paciente:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(_codePatient, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 15),
                    CustomInputField(
                      controller: _controllerPhonePatient,
                      labelText: 'Telefone',
                    ),
                    const SizedBox(height: 10),
                    CustomInputField(
                      controller: _controllerAddressPatient,
                      labelText: 'Endereço',
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        await ProfileInfosPatientService.updateInfosPatient(
                          context,
                          _uid,
                          _controllerPhonePatient.text,
                          _controllerAddressPatient.text,
                        );

                        setState(() {
                          _isLoading = false;
                        });
                      },
                      title: "ATUALIZAR INFORMAÇÕES",
                      titleColor: Colors.white,
                      titleSize: 16,
                      buttonEdgeInsets: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      buttonColor: MyColors.myPrimary,
                      buttonBorderRadius: 10,
                      loadingColor: MyColors.myPrimary,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
