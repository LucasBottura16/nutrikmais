import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/create_account_screen/create_account_service.dart';
import 'package:nutrikmais/patient_screen/models/patient_model.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:nutrikmais/utils/customs_components/custom_button.dart';
import 'package:nutrikmais/utils/customs_components/custom_input_field.dart';
import 'package:nutrikmais/utils/masks.dart';

class FormPatient extends StatefulWidget {
  const FormPatient({super.key});

  @override
  State<FormPatient> createState() => _FormPatientState();
}

class _FormPatientState extends State<FormPatient> {
  final TextEditingController _controllerCodePatient = TextEditingController();
  final TextEditingController _controllerNamePatient = TextEditingController();
  final TextEditingController _controllerAddressPatient =
      TextEditingController();
  final TextEditingController _controllerPhonePatient = TextEditingController();
  final TextEditingController _controllerCPFPatient = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassord = TextEditingController();

  DBPatientModel? foundPatient;

  String? _nameNutritionist;
  String? _crnNutritionist;

  bool _isLoading = false;

  Future getNutritionistInfo() async {
    final uidNutritionist = foundPatient?.uidNutritionistPatient ?? '';

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot doc = await firestore
        .collection('Nutritionists')
        .doc(uidNutritionist)
        .get();

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    setState(() {
      _nameNutritionist = data['nameNutritionist'] ?? '';
      _crnNutritionist = data['crn'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomInputField(
            controller: _controllerCodePatient,
            labelText: "CÓDIGO DO PACIENTE",
            hintText: "Insira o código passado pelo seu nutricionista",
          ),
          foundPatient == null
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Dados do Nutricionista",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MyColors.myPrimary,
                      ),
                    ),
                    Text(
                      "NOME DO NUTRICIONISTA",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_nameNutritionist ?? ""),
                    const SizedBox(height: 10),
                    Text(
                      "CRN DO NUTRICIONISTA",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_crnNutritionist ?? ""),
                    SizedBox(height: 15),
                    Text(
                      "Dados do Paciente",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MyColors.myPrimary,
                      ),
                    ),
                    CustomInputField(
                      labelText: "NOME DO PACIENTE",
                      hintText: "Nome do paciente",
                      controller: _controllerNamePatient,
                    ),
                    CustomInputField(
                      labelText: "ENDEREÇO",
                      hintText: "Endereço do paciente",
                      controller: _controllerAddressPatient,
                    ),
                    CustomInputField(
                      labelText: "TELEFONE",
                      hintText: "Telefone do paciente",
                      controller: _controllerPhonePatient,
                    ),
                    CustomInputField(
                      labelText: "CPF",
                      hintText: "CPF do paciente",
                      controller: _controllerCPFPatient,
                      keyboardType: TextInputType.number,
                      inputFormatters: [MasksInput.cpfFormatter],
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Dados da conta",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MyColors.myPrimary,
                      ),
                    ),
                    CustomInputField(
                      labelText: "EMAIL",
                      hintText: "Email do paciente",
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomInputField(
                      labelText: "SENHA",
                      hintText: "Senha do paciente",
                      controller: _controllerPassord,
                      obscureText: true,
                    ),
                  ],
                ),
          const SizedBox(height: 20),
          foundPatient == null
              ? CustomButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    var patient = await CreateAccountService().validateCode(
                      _controllerCodePatient.text,
                      context,
                    );

                    if (patient == "Erro na validação do código") {
                      setState(() {
                        _isLoading = false;
                      });
                      return;
                    }

                    if (patient == "Conta já está ativa" ||
                        patient == "Estado da conta inválido") {
                      setState(() {
                        _isLoading = false;
                      });
                      return;
                    }

                    setState(() {
                      foundPatient = patient;
                    });

                    setState(() {
                      _controllerNamePatient.text = foundPatient?.patient ?? '';
                      _controllerAddressPatient.text =
                          foundPatient?.address ?? '';
                      _controllerPhonePatient.text = foundPatient?.phone ?? '';
                      _controllerEmail.text = foundPatient?.email ?? '';
                    });

                    await getNutritionistInfo();

                    setState(() {
                      _isLoading = false;
                    });
                  },
                  title: "VALIDAR CÓDIGO",
                  titleColor: Colors.white,
                  buttonColor: MyColors.myPrimary,
                  buttonBorderRadius: 10,
                  buttonEdgeInsets: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                  isLoading: _isLoading,
                  loadingColor: MyColors.myPrimary,
                )
              : CustomButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    await CreateAccountService().createPatient(
                      context,
                      foundPatient!.uidNutritionistPatient,
                      foundPatient!.gender,
                      foundPatient!.age,
                      foundPatient!.codePatient,
                      foundPatient!.lastschedule,
                      foundPatient!.photo,
                      foundPatient!.uidAccount,
                      _controllerNamePatient.text,
                      _controllerAddressPatient.text,
                      _controllerPhonePatient.text,
                      _controllerCPFPatient.text,
                      _controllerEmail.text,
                      _controllerPassord.text,
                      "patient",
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
      ),
    );
  }
}
