import 'package:flutter/material.dart';
import 'package:nutrikmais/patient_screen/add_pacient_screen/add_patient_service.dart';
import 'package:nutrikmais/globals/configs/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs_components/custom_button.dart';
import 'package:nutrikmais/globals/customs_components/custom_dropdown.dart';
import 'package:nutrikmais/globals/customs_components/custom_input_field.dart';
import 'package:nutrikmais/utils/masks.dart';

class AddPatientView extends StatefulWidget {
  const AddPatientView({super.key});

  @override
  State<AddPatientView> createState() => _AddPatientViewState();
}

class _AddPatientViewState extends State<AddPatientView> {
  final TextEditingController _controllerPatient = TextEditingController();
  final TextEditingController _controllerAge = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();

  bool _isLoading = false;

  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Adicionar Paciente",
        backgroundColor: MyColors.myPrimary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomInputField(
                        controller: _controllerPatient,
                        labelText: "Nome do Paciente",
                        hintText: "Digite o nome do paciente",
                      ),
                      SizedBox(height: 16),
                      CustomDropdown<String>(
                        value: _selectedGender,
                        hintText: 'Escolha um genêro',
                        items: AddPatientService.listGender(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue;
                          });
                        },
                        labelText: 'Genêro',
                      ),
                      CustomInputField(
                        controller: _controllerAge,
                        labelText: "Idade",
                        hintText: "Digite a idade do paciente",
                        keyboardType: TextInputType.number,
                      ),
                      CustomInputField(
                        controller: _controllerPhone,
                        labelText: "Telefone",
                        hintText: "(11) 9 9999-9999",
                        keyboardType: TextInputType.phone,
                        inputFormatters: [MasksInput.phoneFormatter],
                      ),
                      CustomInputField(
                        controller: _controllerAddress,
                        labelText: "Endereço",
                        hintText: "Digite o endereço do paciente",
                      ),
                      CustomInputField(
                        controller: _controllerEmail,
                        labelText: "Email",
                        hintText: "Digite o email do paciente",
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    await AddPatientService().createPatient(
                      context,
                      _controllerPatient.text,
                      _selectedGender ?? '',
                      _controllerAge.text,
                      _controllerPhone.text,
                      _controllerAddress.text,
                      _controllerEmail.text,
                    );

                    setState(() {
                      _isLoading = false;
                    });
                  },
                  title: "CADASTRAR NOVO PACIENTE",
                  titleColor: Colors.white,
                  titleSize: 16,
                  buttonEdgeInsets: const EdgeInsets.symmetric(vertical: 20),
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
