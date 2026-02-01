import 'package:flutter/material.dart';
import 'package:nutrikmais/patient_screen/models/patient_model.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ModalPatientView extends StatefulWidget {
  const ModalPatientView({super.key, required this.patient});

  final DBPatientModel patient;

  @override
  State<ModalPatientView> createState() => _ModalPatientViewState();
}

class _ModalPatientViewState extends State<ModalPatientView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                Icon(Icons.backspace_rounded, size: 20),
                SizedBox(width: 10),
                Text(
                  "FECHAR",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ],
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: widget.patient.photo == "null"
                    ? Image.asset(
                        "images/Logo.png",
                        color: MyColors.myPrimary,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        widget.patient.photo,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 15),
              Text(
                widget.patient.patient,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MyColors.myPrimary,
                ),
              ),
              Text(
                "Conta: ${widget.patient.stateAccount}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              Text(
                "Código: ${widget.patient.codePatient}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              Text(
                "E-mail: ${widget.patient.email}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              Text(
                "Telefone: ${widget.patient.phone}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              Text(
                "Última Consulta: ${widget.patient.lastschedule}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  String cleanPhoneNumber = widget.patient.phone.replaceAll(
                    RegExp(r'[^0-9]'),
                    '',
                  );

                  final message = widget.patient.stateAccount == 'pending'
                      ? 'Olá ${widget.patient.patient}, seu codigo para criação é de conta é ${widget.patient.codePatient}.'
                      : 'Olá ${widget.patient.patient}, gostaria de entrar em contato com você.';
                  final url =
                      'whatsapp://send?phone=55$cleanPhoneNumber&text=$message';
                  await launchUrl(Uri.parse(url));
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.resolveWith<OutlinedBorder>((
                    Set<WidgetState> states,
                  ) {
                    return RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    );
                  }),
                  backgroundColor: WidgetStateProperty.all<Color>(
                    MyColors.myPrimary,
                  ),
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.fromLTRB(15, 9, 15, 9),
                  ),
                ),
                child: const Text(
                  "CHAMAR NO WHATSAPP",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
