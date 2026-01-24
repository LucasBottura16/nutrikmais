import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BioimpedanceService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static StreamSubscription<QuerySnapshot> addListenerBioimpedances(
    StreamController<QuerySnapshot> controllerStream, {
    String? uidPatient,
    String? typeUser,
  }) {
    Query collection = firestore.collection('Bioimpedance');

    Query query;
    
    if (typeUser == "patient") {
      // Se for paciente, busca pelas bioimpedâncias do paciente
      query = collection
          .where('uidPatient', isEqualTo: auth.currentUser?.uid)
          .orderBy('bioimpedanceUpdatedAt', descending: false);
    } else {
      // Se for nutricionista, busca pelas bioimpedâncias do nutricionista
      query = collection
          .where('uidNutritionist', isEqualTo: auth.currentUser?.uid)
          .orderBy('bioimpedanceUpdatedAt', descending: false);
      
      if (uidPatient != null && uidPatient.isNotEmpty) {
        query = query
            .where('uidPatient', isEqualTo: uidPatient)
            .orderBy('bioimpedanceUpdatedAt', descending: false);
      }
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
