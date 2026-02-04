import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class EatingPlansService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static StreamSubscription<QuerySnapshot> addListenerEatingPlans(
    StreamController<QuerySnapshot> controllerStream, {
    String? uidAccount,
    String? typeUser,
  }) {
    Query collection = firestore.collection('EatingPlans');

    Query query;

    if (typeUser == "patient") {
      debugPrint('Buscando planos alimentares para o paciente: $uidAccount');
      query = collection
          .where('uidAccount', isEqualTo: uidAccount)
          .orderBy('eatingPlansUpdatedAt', descending: false);
    } else {
      query = collection
          .where('uidNutritionist', isEqualTo: auth.currentUser?.uid)
          .orderBy('eatingPlansUpdatedAt', descending: false);

      if (uidAccount != null && uidAccount.isNotEmpty) {
        query = query
            .where('uidAccount', isEqualTo: uidAccount)
            .orderBy('eatingPlansUpdatedAt', descending: false);
      }
    }

    final subscription = query.snapshots().listen((event) {
      controllerStream.add(event);
    });

    return subscription;
  }

  static Future<void> deleteEatingPlan(String docId) async {
    await firestore.collection('EatingPlans').doc(docId).delete();
  }
}
