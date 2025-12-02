import 'package:cloud_firestore/cloud_firestore.dart';

class DBOrientations {
  String? _uidOrientations;
  String? _orientationsUpdatedAt;
  String? _uidNutritionist;
  String? _uidPatient;
  String? _patientName;
  List<String>? _orientations;

  DBOrientations();

  DBOrientations.fromDocumentSnapshotOrientations(
    DocumentSnapshot documentSnapshot,
  ) {
    uidOrientations = documentSnapshot['uidOrientations'];
    orientations = List<String>.from(documentSnapshot['orientations']);
    orientationsUpdatedAt = documentSnapshot['orientationsUpdatedAt'];
    uidNutritionist = documentSnapshot['uidNutritionist'];
    uidPatient = documentSnapshot['uidPatient'];
    patientName = documentSnapshot['patientName'];
  }

  Map<String, dynamic> toMap(uidOrientations) {
    Map<String, dynamic> map() {
      return {
        'uidOrientations': uidOrientations,
        'orientations': _orientations,
        'orientationsUpdatedAt': _orientationsUpdatedAt,
        'uidNutritionist': _uidNutritionist,
        'uidPatient': _uidPatient,
        'patientName': _patientName,
      };
    }

    return map();
  }

  String? get patientName => _patientName;
  set patientName(String? value) {
    _patientName = value;
  }

  String get uidOrientations => _uidOrientations!;
  set uidOrientations(String? value) {
    _uidOrientations = value;
  }

  List<String> get orientations => _orientations!;
  set orientations(List<String>? value) {
    _orientations = value;
  }

  String get orientationsUpdatedAt => _orientationsUpdatedAt!;
  set orientationsUpdatedAt(String? value) {
    _orientationsUpdatedAt = value;
  }

  String get uidNutritionist => _uidNutritionist!;
  set uidNutritionist(String? value) {
    _uidNutritionist = value;
  }

  String get uidPatient => _uidPatient!;
  set uidPatient(String? value) {
    _uidPatient = value;
  }
}
