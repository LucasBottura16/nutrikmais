import 'package:cloud_firestore/cloud_firestore.dart';

class DBBioimpedance {
  String? _uidBioimpedance;
  String? _bioimpedanceUpdatedAt;
  String? _uidNutritionist;
  String? _uidAccount;
  String? _patientName;
  List<String>? _bioimpedanceImages;

  DBBioimpedance();

  DBBioimpedance.fromDocumentSnapshotBioimpedance(
    DocumentSnapshot documentSnapshot,
  ) {
    uidBioimpedance = documentSnapshot['uidBioimpedance'];
    bioimpedanceImages = List<String>.from(
      documentSnapshot['bioimpedanceImages'],
    );
    bioimpedanceUpdatedAt = documentSnapshot['bioimpedanceUpdatedAt'];
    uidNutritionist = documentSnapshot['uidNutritionist'];
    uidAccount = documentSnapshot['uidAccount'];
    patientName = documentSnapshot['patientName'];
  }

  Map<String, dynamic> toMap(uidBioimpedance) {
    Map<String, dynamic> map() {
      return {
        'uidBioimpedance': uidBioimpedance,
        'bioimpedanceImages': _bioimpedanceImages,
        'bioimpedanceUpdatedAt': _bioimpedanceUpdatedAt,
        'uidNutritionist': _uidNutritionist,
        'uidAccount': _uidAccount,
        'patientName': _patientName,
      };
    }

    return map();
  }

  String get patientName => _patientName!;
  set patientName(String? value) {
    _patientName = value;
  }

  String get uidBioimpedance => _uidBioimpedance!;
  set uidBioimpedance(String? value) {
    _uidBioimpedance = value;
  }

  List<String> get bioimpedanceImages => _bioimpedanceImages!;
  set bioimpedanceImages(List<String>? value) {
    _bioimpedanceImages = value;
  }

  String get bioimpedanceUpdatedAt => _bioimpedanceUpdatedAt!;
  set bioimpedanceUpdatedAt(String? value) {
    _bioimpedanceUpdatedAt = value;
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
