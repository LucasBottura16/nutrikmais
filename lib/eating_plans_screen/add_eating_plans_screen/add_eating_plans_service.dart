import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrikmais/eating_plans_screen/models/eating_plans_model.dart';
import 'package:nutrikmais/utils/random_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddEatingPlansService {
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

  Future<void> createEatingPlan(
    BuildContext context,
    String uidAccount,
    String patient,
    List<String>? eatingPlans,
  ) async {
    if (uidAccount.isEmpty || patient.isEmpty || eatingPlans == null) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Erro ao cadastrar plano alimentar"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [Text("Preencha todos os campos!")],
            ),
          );
        },
      );
    } else {
      await completedRegister(uidAccount, patient, eatingPlans);

      if (!context.mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> completedRegister(
    String uidAccount,
    String patient,
    List<String>? eatingPlans,
  ) async {
    DBEatingPlans eatingPlanData = DBEatingPlans();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uidNutritionist = prefs.getString('uidLogged') ?? '';

    eatingPlanData.uidAccount = uidAccount;
    eatingPlanData.patientName = patient;
    eatingPlanData.uidNutritionist = uidNutritionist;
    eatingPlanData.eatingPlansUpdatedAt = DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now());
    eatingPlanData.eatingPlans = eatingPlans;

    String uidEatingPlans = RandomKeys().generateRandomString();

    await firestore
        .collection("EatingPlans")
        .doc(uidEatingPlans)
        .set(eatingPlanData.toMap(uidEatingPlans));
  }
}
