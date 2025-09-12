import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<Stream<QuerySnapshot>?>? addListenerPatient(
    StreamController<QuerySnapshot> controllerStream,
  ) async {
    Stream<QuerySnapshot> stream = firestore
        .collection("Patients")
        .where("uidNutritionist", isEqualTo: auth.currentUser?.uid)
        .snapshots();

    stream.listen((event) {
      controllerStream.add(event);
    });

    return null;
  }
}
