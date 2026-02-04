import 'package:cloud_firestore/cloud_firestore.dart';

class DBEatingPlans {
  String? _uidEatingPlans;
  String? _eatingPlansUpdatedAt;
  String? _uidNutritionist;
  String? _uidAccount;
  String? _patientName;
  List<String>? _eatingPlans;

  DBEatingPlans();

  DBEatingPlans.fromDocumentSnapshotEatingPlans(
    DocumentSnapshot documentSnapshot,
  ) {
    uidEatingPlans = documentSnapshot['uidEatingPlans'];
    eatingPlans = List<String>.from(documentSnapshot['eatingPlans']);
    eatingPlansUpdatedAt = documentSnapshot['eatingPlansUpdatedAt'];
    uidNutritionist = documentSnapshot['uidNutritionist'];
    uidAccount = documentSnapshot['uidAccount'];
    patientName = documentSnapshot['patientName'];
  }

  Map<String, dynamic> toMap(uidEatingPlans) {
    Map<String, dynamic> map() {
      return {
        'uidEatingPlans': uidEatingPlans,
        'eatingPlans': _eatingPlans,
        'eatingPlansUpdatedAt': _eatingPlansUpdatedAt,
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

  String get uidEatingPlans => _uidEatingPlans!;
  set uidEatingPlans(String? value) {
    _uidEatingPlans = value;
  }

  List<String> get eatingPlans => _eatingPlans!;
  set eatingPlans(List<String>? value) {
    _eatingPlans = value;
  }

  String get eatingPlansUpdatedAt => _eatingPlansUpdatedAt!;
  set eatingPlansUpdatedAt(String? value) {
    _eatingPlansUpdatedAt = value;
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
