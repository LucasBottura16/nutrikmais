import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// removed unused intl import

class ConsultationsServices {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static StreamSubscription<QuerySnapshot<Object?>>? _subscription;

  static Future<void> addListenerConsultations(
    StreamController<QuerySnapshot> controllerStream,
    String date, {
    String? typeUser,
    String? uidAccount,
  }) async {
    // cancel previous subscription if exists
    try {
      await _subscription?.cancel();
    } catch (_) {}

    Query stream = firestore.collection("Consultations");
    
    if (typeUser == "patient") {
      // Se for paciente, busca pelas consultas do paciente
      stream = stream
          .where("uidAccount", isEqualTo: uidAccount)
          .where("dateConsultation", isEqualTo: date)
          .orderBy("timeConsultation");
    } else {
      // Se for nutricionista, busca pelas consultas do nutricionista
      stream = stream
          .where("uidNutritionist", isEqualTo: auth.currentUser?.uid)
          .where("dateConsultation", isEqualTo: date)
          .orderBy("timeConsultation");
    }

    _subscription = stream.snapshots().listen((event) {
      controllerStream.add(event);
    });

    return;
  }

  static Future<void> finalizeConsultation(String docId) async {
    try {
      final doc = await firestore.collection('Consultations').doc(docId).get();
      final current = doc.data()?['status'];
      if (current == 'Finalizada') {
        throw Exception('Consulta já finalizada');
      }
      await firestore.collection('Consultations').doc(docId).update({
        'status': 'Finalizada',
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> cancelConsultation(String docId) async {
    try {
      final doc = await firestore.collection('Consultations').doc(docId).get();
      final current = doc.data()?['status'];
      if (current == 'Cancelada') {
        throw Exception('Consulta já cancelada');
      }
      await firestore.collection('Consultations').doc(docId).update({
        'status': 'Cancelada',
      });
    } catch (e) {
      rethrow;
    }
  }
}
