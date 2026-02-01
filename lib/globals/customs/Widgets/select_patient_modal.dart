import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/orientations_screen/orientations_service.dart';

/// Shows a modal with a list of patients and returns the selected patient's uid as String.
///
/// Parameters:
/// - [context]: BuildContext for navigation
/// - [title]: Title of the modal (default: 'Filtrar por paciente')
/// - [showAllPatients]: If true, shows all patients. If false, shows only patients with consultations (default: false)
Future<String?> selectPatientModal(
  BuildContext context, {
  String title = 'Filtrar por paciente',
  bool showAllPatients = false,
}) async {
  try {
    final Map<String, String> patients = {}; // uidAccount -> name

    if (showAllPatients) {
      // Fetch all patients for this nutritionist from Patients collection
      final docs = await FirebaseFirestore.instance
          .collection('Patients')
          .where(
            'uidNutritionist',
            isEqualTo: OrientationsService.auth.currentUser?.uid,
          )
          .get();

      for (var d in docs.docs) {
        final data = d.data();
        final uid = (data['uidAccount'] ?? '').toString();
        final name = (data['patient'] ?? '').toString();
        if (uid.isNotEmpty && name.isNotEmpty) patients[uid] = name;
      }
    } else {
      // Fetch only patients with orientations/consultations
      final docs = await FirebaseFirestore.instance
          .collection('Orientations')
          .where(
            'uidNutritionist',
            isEqualTo: OrientationsService.auth.currentUser?.uid,
          )
          .get();

      for (var d in docs.docs) {
        final data = d.data();
        final uid = (data['uidAccount'] ?? '').toString();
        final name = (data['patientName'] ?? data['patient'] ?? '').toString();
        if (uid.isNotEmpty) patients[uid] = name;
      }
    }

    final entries = patients.entries.toList();

    return showModalBottomSheet<String?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final searchController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            // Filter entries based on search query
            final filteredEntries = entries
                .where(
                  (entry) => entry.value.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  ),
                )
                .toList();

            return Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: MyColors.myPrimary,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Search Filter
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Digitar nome do paciente...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                // Content
                Expanded(
                  child: entries.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum paciente encontrado',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : filteredEntries.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum paciente encontrado com esse nome',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: filteredEntries.length + 1,
                          itemBuilder: (context, index) {
                            // First item: "Todos" option
                            if (index == 0) {
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 8,
                                ),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12),
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: MyColors.myPrimary.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.people,
                                      color: MyColors.myPrimary,
                                    ),
                                  ),
                                  title: const Text(
                                    'Todos',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: const Text('Remover filtro'),
                                  onTap: () => Navigator.of(context).pop(''),
                                ),
                              );
                            }

                            // Patient items
                            final pair = filteredEntries[index - 1];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 8,
                              ),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: MyColors.myPrimary.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: MyColors.myPrimary,
                                  ),
                                ),
                                title: Text(
                                  pair.value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                onTap: () =>
                                    Navigator.of(context).pop(pair.key),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  } catch (e) {
    debugPrint('Erro ao carregar pacientes no modal: $e');
    return null;
  }
}
