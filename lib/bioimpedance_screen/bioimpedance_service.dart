import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BioimpedanceService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static StreamSubscription<QuerySnapshot> addListenerBioimpedances(
    StreamController<QuerySnapshot> controllerStream, {
    String? uidPatient,
  }) {
    Query collection = firestore.collection('Bioimpedance');

    Query query = collection
        .where('uidNutritionist', isEqualTo: auth.currentUser?.uid)
        .orderBy('bioimpedanceUpdatedAt', descending: false);
    if (uidPatient != null && uidPatient.isNotEmpty) {
      query = query
          .where('uidPatient', isEqualTo: uidPatient)
          .orderBy('bioimpedanceUpdatedAt', descending: false);
    }

    final subscription = query.snapshots().listen((event) {
      controllerStream.add(event);
    });

    return subscription;
  }

  static Future<void> deleteBioimpedance(String docId) async {
    await firestore.collection('Bioimpedance').doc(docId).delete();
  }
}
