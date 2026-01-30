import 'package:flutter/material.dart';
import 'package:nutrikmais/create_account_screen/components/form_nutritionist.dart';
import 'package:nutrikmais/create_account_screen/components/form_patient.dart';
import 'package:nutrikmais/globals/customs/Widgets/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  bool _selectedButton = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Criar Conta",
        backgroundColor: MyColors.myPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "CRIAR CONTA",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedButton = true;
                          });
                        },
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.resolveWith<OutlinedBorder>((
                                Set<WidgetState> states,
                              ) {
                                return RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                    width: _selectedButton == true ? 0.0 : 1.0,
                                    color: _selectedButton == true
                                        ? MyColors.myPrimary
                                        : MyColors.myPrimary,
                                  ),
                                );
                              }),
                          backgroundColor: WidgetStateProperty.all<Color>(
                            _selectedButton == true
                                ? MyColors.myPrimary
                                : MyColors.mySecondary,
                          ),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        child: Text(
                          "Paciente",
                          style: TextStyle(
                            color: _selectedButton == true
                                ? Colors.white
                                : MyColors.myPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedButton = false;
                          });
                        },
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.resolveWith<OutlinedBorder>((
                                Set<WidgetState> states,
                              ) {
                                return RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                    width: _selectedButton == false ? 0.0 : 1.0,
                                    color: _selectedButton == false
                                        ? MyColors.myPrimary
                                        : MyColors.myPrimary,
                                  ),
                                );
                              }),
                          backgroundColor: WidgetStateProperty.all<Color>(
                            _selectedButton == false
                                ? MyColors.myPrimary
                                : MyColors.mySecondary,
                          ),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        child: Text(
                          "Nutricionista",
                          style: TextStyle(
                            color: _selectedButton == false
                                ? Colors.white
                                : MyColors.myPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _selectedButton == true ? FormPatient() : FormNutritionist(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
