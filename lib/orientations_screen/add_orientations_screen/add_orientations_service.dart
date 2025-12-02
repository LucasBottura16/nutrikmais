import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrikmais/orientations_screen/models/orientations_model.dart';
import 'package:nutrikmais/utils/random_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddOrientationsService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<QueryDocumentSnapshot>> getScheduledConsultations() async {
    try {
      final querySnapshot = await firestore
          .collection('Consultations')
          .where('uidNutritionist', isEqualTo: auth.currentUser?.uid)
          .where('status', isEqualTo: 'Agendada')
          .orderBy('dateConsultation')
          .orderBy('timeConsultation')
          .get();

      return querySnapshot.docs;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createOrientation(
    BuildContext context,
    String uidPatient,
    String patient,
    List<String>? orientations,
  ) async {
    if (uidPatient.isEmpty || patient.isEmpty || orientations == null) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Erro ao cadastrar orientações"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [Text("Preencha todos os campos!")],
            ),
          );
        },
      );
    } else {
      await completedRegister(uidPatient, patient, orientations);

      if (!context.mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> completedRegister(
    String uidPatient,
    String patient,
    List<String>? orientations,
  ) async {
    DBOrientations orientationData = DBOrientations();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uidNutritionist = prefs.getString('uidLogged') ?? '';

    orientationData.uidPatient = uidPatient;
    orientationData.patientName = patient;
    orientationData.uidNutritionist = uidNutritionist;
    orientationData.orientationsUpdatedAt = DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now());
    orientationData.orientations = orientations;

    String uidOrientations = RandomKeys().generateRandomString();

    await firestore
        .collection("Orientations")
        .doc(uidOrientations)
        .set(orientationData.toMap(uidOrientations));
  }
}
