import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrientationsService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static StreamSubscription<QuerySnapshot> addListenerOrientations(
    StreamController<QuerySnapshot> controllerStream, {
    String? uidPatient,
    String? typeUser,
  }) {
    Query collection = firestore.collection('Orientations');

    Query query;
    
    if (typeUser == "patient") {
      // Se for paciente, busca pelas orientações do paciente
      query = collection
          .where('uidPatient', isEqualTo: auth.currentUser?.uid)
          .orderBy('orientationsUpdatedAt', descending: false);
    } else {
      // Se for nutricionista, busca pelas orientações do nutricionista
      query = collection
          .where('uidNutritionist', isEqualTo: auth.currentUser?.uid)
          .orderBy('orientationsUpdatedAt', descending: false);

      if (uidPatient != null && uidPatient.isNotEmpty) {
        query = query
            .where('uidPatient', isEqualTo: uidPatient)
            .orderBy('orientationsUpdatedAt', descending: false);
      }
    }

    final subscription = query.snapshots().listen((event) {
      controllerStream.add(event);
    });

    return subscription;
  }

  static Future<void> deleteOrientation(String docId) async {
    await firestore.collection('Orientations').doc(docId).delete();
  }
}
