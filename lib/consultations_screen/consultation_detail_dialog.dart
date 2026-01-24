import 'package:flutter/material.dart';
import 'package:nutrikmais/consultations_screen/consultations_services.dart';
import 'package:nutrikmais/consultations_screen/models/consultations_model.dart';
import 'package:nutrikmais/utils/customs_components/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showConsultationDetailDialog(
  BuildContext context,
  DBConsultationsModel consultation,
  String docId,
) async {
  final prefs = await SharedPreferences.getInstance();
  final typeUser = prefs.getString('typeUser') ?? '';
  final isNutritionist = typeUser != 'patient';

  if (!context.mounted) return;
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text(
          'Detalhes da Consulta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Paciente: ${consultation.patient ?? ''}'),
              const SizedBox(height: 8),
              Text('Data: ${consultation.dateConsultation ?? ''}'),
              const SizedBox(height: 8),
              Text('Hora: ${consultation.timeConsultation ?? ''}'),
              const SizedBox(height: 8),
              Text('Serviço: ${consultation.serviceName ?? ''}'),
              const SizedBox(height: 8),
              Text('Preço: ${consultation.price ?? ''}'),
              const SizedBox(height: 8),
              Text('Local: ${consultation.place ?? ''}'),
              const SizedBox(height: 8),
              Text('Status: ${consultation.status ?? ''}'),
              if (isNutritionist) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Builder(
                      builder: (ctx) {
                        final status = consultation.status ?? '';
                        final canCancel = status != 'Cancelada';
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.32,
                          child: CustomButton(
                            onPressed: () async {
                              if (canCancel) {
                                try {
                                  await ConsultationsServices.cancelConsultation(
                                    docId,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Consulta cancelada'),
                                    ),
                                  );
                                  Navigator.of(dialogContext).pop();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Erro: $e')),
                                  );
                                }
                              }
                            },
                            title: canCancel ? 'Cancelar' : 'Cancelada',
                            titleColor: canCancel
                                ? Colors.white
                                : Colors.grey.shade400,
                            buttonColor: canCancel ? Colors.red : Colors.grey,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    Builder(
                      builder: (ctx) {
                        final status = consultation.status ?? '';
                        final canFinalize = status != 'Finalizada';
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.32,
                          child: CustomButton(
                            onPressed: () async {
                              if (canFinalize) {
                                try {
                                  await ConsultationsServices.finalizeConsultation(
                                    docId,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Consulta finalizada'),
                                    ),
                                  );
                                  Navigator.of(dialogContext).pop();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Erro: $e')),
                                  );
                                }
                              }
                            },
                            title: canFinalize ? 'Finalizar' : 'Finalizada',
                            titleColor: canFinalize
                                ? Colors.white
                                : Colors.grey.shade400,
                            buttonColor: canFinalize
                                ? Colors.green
                                : Colors.grey,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
