import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_consultations_service.dart';
import 'package:nutrikmais/globals/configs/colors.dart';

Future<QueryDocumentSnapshot?> showPatientSelectorDialog(BuildContext context) {
  return showDialog<QueryDocumentSnapshot?>(
    context: context,
    builder: (context) {
      return FutureBuilder<List<QueryDocumentSnapshot>>(
        future: AddConsultationsService().getPatients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AlertDialog(
              content: SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          if (snapshot.hasError) {
            return AlertDialog(
              content: Text('Erro ao carregar pacientes: ${snapshot.error}'),
            );
          }

          final patientsList = snapshot.data ?? [];

          return AlertDialog(
            title: const Text('Selecionar Paciente'),
            content: SizedBox(
              width: double.maxFinite,
              child: patientsList.isEmpty
                  ? const Text('Nenhum paciente encontrado.')
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: patientsList.length,
                      itemBuilder: (context, index) {
                        final doc = patientsList[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final name =
                            data['patient'] ?? data['name'] ?? 'Sem nome';
                        final photo = data['photo'] ?? '';

                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: photo == 'null' || photo == ''
                                ? Image.asset(
                                    'images/Logo.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    color: MyColors.myPrimary,
                                  )
                                : Image.network(
                                    photo,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          title: Text(name),
                          onTap: () => Navigator.of(context).pop(doc),
                        );
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Cancelar'),
              ),
            ],
          );
        },
      );
    },
  );
}
