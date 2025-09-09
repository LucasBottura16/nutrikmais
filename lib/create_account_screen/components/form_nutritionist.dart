import 'package:flutter/material.dart';
import 'package:nutrikmais/create_account_screen/create_account_service.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:nutrikmais/utils/customs_components/custom_button.dart';
import 'package:nutrikmais/utils/customs_components/custom_dropdown.dart';
import 'package:nutrikmais/utils/customs_components/custom_input_field.dart';
import 'package:nutrikmais/utils/masks.dart';
import 'package:nutrikmais/utils/customs_components/customs_multidropdown.dart';

class FormNutritionist extends StatefulWidget {
  const FormNutritionist({super.key});

  @override
  State<FormNutritionist> createState() => _FormNutritionistState();
}

class _FormNutritionistState extends State<FormNutritionist> {
  final TextEditingController _controllerNutritionist = TextEditingController();
  final TextEditingController _controllerCPF = TextEditingController();
  final TextEditingController _controllerCRN = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _isLoading = false;

  String? _selectedState;
  List<String> _selectedService = [];
  String? _selectedCare;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "INFORMAÇÕES DO NUTRICIONISTA",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        CustomInputField(
          controller: _controllerNutritionist,
          labelText: "NOME DO NUTRICIONISTA",
          hintText: "Digite seu nome",
        ),
        CustomInputField(
          controller: _controllerCPF,
          labelText: "CPF",
          hintText: "000.000.000-00",
          keyboardType: TextInputType.number,
          inputFormatters: [MasksInput.cpfFormatter],
        ),
        CustomInputField(
          controller: _controllerCRN,
          labelText: "CRN",
          hintText: "3 12345",
          keyboardType: TextInputType.number,
          prefix: "CRN-",
        ),
        const SizedBox(height: 10),
        CustomDropdown<String>(
          value: _selectedState,
          hintText: 'Escolha um estado',
          items: CreateAccountService.listStates(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedState = newValue;
            });
          },
          labelText: 'ESTADO',
        ),
        const SizedBox(height: 10),
        CustomDropdown<String>(
          value: _selectedCare,
          hintText: 'Escolha um tipo de atuação',
          items: CreateAccountService.listCare(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCare = newValue;
            });
          },
          labelText: 'TIPOS DE ATUAÇÃO',
        ),
        CustomMultiSelectDropdown<String>(
          hintText: 'Areas de atendimento',
          labelText: 'ÁREAS DE ATENDIMENTO',
          items: CreateAccountService.listService(),
          value: _selectedService,
          selectItemfinal: _selectedService,
          onChanged: (newValue) {
            setState(() {
              _selectedService = newValue;
            });
          },
        ),
        CustomInputField(
          controller: _controllerAddress,
          labelText: "ENDEREÇO",
          hintText: "nome da rua",
        ),
        CustomInputField(
          controller: _controllerPhone,
          labelText: "Telefone",
          hintText: "(11) 9 9999-9999",
          keyboardType: TextInputType.number,
          inputFormatters: [MasksInput.phoneFormatter],
        ),
        const SizedBox(height: 30),
        const Text(
          "INFORMAÇÕES DA CONTA",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        CustomInputField(
          controller: _controllerEmail,
          labelText: "EMAIL",
          hintText: "exemplo@email.com",
        ),
        CustomInputField(
          controller: _controllerPassword,
          labelText: "SENHA",
          hintText: "******",
          obscureText: true,
        ),
        const SizedBox(height: 20),
        CustomButton(
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });

            await CreateAccountService().createUser(
              context,
              _controllerEmail.text,
              _controllerPassword.text,
              _controllerNutritionist.text,
              _controllerCPF.text,
              "CRN-${_controllerCRN.text}",
              _selectedState!,
              _selectedService,
              _selectedCare!,
              _controllerAddress.text,
              _controllerPhone.text,
              "nutritionist",
            );

            setState(() {
              _isLoading = false;
            });
          },
          title: "CRIAR CONTA",
          titleColor: Colors.white,
          buttonColor: MyColors.myPrimary,
          buttonBorderRadius: 10,
          buttonEdgeInsets: const EdgeInsets.fromLTRB(50, 15, 50, 15),
          isLoading: _isLoading,
          loadingColor: MyColors.myPrimary,
        ),
      ],
    );
  }
}
