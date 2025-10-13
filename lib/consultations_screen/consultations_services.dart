import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConsultationsServices {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<Stream<QuerySnapshot>?>? addListenerConsultations(
    StreamController<QuerySnapshot> controllerStream,
  ) async {
    Stream<QuerySnapshot> stream = firestore
        .collection("Consultations")
        .where("uidNutritionist", isEqualTo: auth.currentUser?.uid)
        .snapshots();

    stream.listen((event) {
      controllerStream.add(event);
    });

    return null;
  }
}
