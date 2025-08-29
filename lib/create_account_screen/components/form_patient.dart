import 'package:flutter/material.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:nutrikmais/utils/customs_components/custom_button.dart';
import 'package:nutrikmais/utils/customs_components/custom_input_field.dart';

class FormPatient extends StatefulWidget {
  const FormPatient({super.key});

  @override
  State<FormPatient> createState() => _FormPatientState();
}

class _FormPatientState extends State<FormPatient> {
  final TextEditingController _controllerCodePatient = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputField(
          controller: _controllerCodePatient,
          labelText: "CÓDIGO DO PACIENTE",
          hintText: "Insira o código passado pelo seu nutricionista",
        ),
        const SizedBox(height: 20),
        CustomButton(
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });

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
