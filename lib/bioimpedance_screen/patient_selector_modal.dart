import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/bioimpedance_screen/bioimpedance_service.dart';

/// Shows a modal with a list of patients (from Bioimpedance collection) and returns
/// the selected patient's uid as String. Returns null if cancelled.
Future<String?> showPatientSelectorDialog(BuildContext context) async {
  try {
    // Fetch all bioimpedances for this nutritionist and extract unique patients
    final docs = await FirebaseFirestore.instance
        .collection('Bioimpedance')
        .where(
          'uidNutritionist',
          isEqualTo: BioimpedanceService.auth.currentUser?.uid,
        )
        .get();

    final Map<String, String> patients = {}; // uid -> name

    for (var d in docs.docs) {
      final data = d.data();
      final uid = (data['uidAccount'] ?? '').toString();
      final name = (data['patientName'] ?? data['patient'] ?? '').toString();
      if (uid.isNotEmpty) patients[uid] = name;
    }

    final entries = patients.entries.toList();

    return showDialog<String?>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Filtrar por paciente'),
          content: SizedBox(
            width: double.maxFinite,
            child: entries.isEmpty
                ? const Text('Nenhum paciente encontrado')
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: entries.length + 1,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ListTile(
                          title: const Text('Todos'),
                          subtitle: const Text('Remover filtro'),
                          onTap: () => Navigator.of(ctx).pop(''),
                        );
                      }
                      final pair = entries[index - 1];
                      return ListTile(
                        title: Text(pair.value),
                        onTap: () => Navigator.of(ctx).pop(pair.key),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    debugPrint('Erro ao carregar pacientes no modal: $e');
    return null;
  }
}
