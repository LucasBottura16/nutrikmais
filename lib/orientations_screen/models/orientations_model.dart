import 'package:cloud_firestore/cloud_firestore.dart';

class DBOrientations {
  String? _uidOrientations;
  String? _orientationsUpdatedAt;
  String? _uidNutritionist;
  String? _uidAccount;
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
    uidAccount = documentSnapshot['uidAccount'];
    patientName = documentSnapshot['patientName'];
  }

  Map<String, dynamic> toMap(uidOrientations) {
    Map<String, dynamic> map() {
      return {
        'uidOrientations': uidOrientations,
        'orientations': _orientations,
        'orientationsUpdatedAt': _orientationsUpdatedAt,
        'uidNutritionist': _uidNutritionist,
        'uidAccount': _uidAccount,
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

  String get uidAccount => _uidAccount!;
  set uidAccount(String? value) {
    _uidAccount = value;
  }
}
