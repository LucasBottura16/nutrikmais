import 'package:cloud_firestore/cloud_firestore.dart';

class DBPatientModel {
  String? _uidPatient;
  String? _patient;
  String? _gender;
  String? _age;
  String? _phone;
  String? _cpf;
  String? _address;
  String? _email;
  String? _codePatient;
  String? _uidAccount;
  String? _typeUser;
  String? _photo;
  String? _lastschedule;
  String? _nameNutritionist;
  String? _crnNutritionist;
  String? _uidNutritionist;

  DBPatientModel();

  DBPatientModel.fromDocumentSnapshotPatients(
    DocumentSnapshot documentSnapshot,
  ) {
    uidAccount = documentSnapshot['uidAccount'];
    uidNutritionistPatient = documentSnapshot['uidNutritionist'];
    patient = documentSnapshot['patient'];
    gender = documentSnapshot['gender'];
    age = documentSnapshot['age'];
    phone = documentSnapshot['phone'];
    address = documentSnapshot['address'];
    email = documentSnapshot['email'];
    codePatient = documentSnapshot['codePatient'];
    typeUser = documentSnapshot['typeUser'];
    photo = documentSnapshot['photo'];
    lastschedule = documentSnapshot['lastschedule'];
    nameNutritionist = documentSnapshot['nameNutritionist'];
    crnNutritionist = documentSnapshot['crnNutritionist'];
    cpf = documentSnapshot['cpf'];
    uidPatient = documentSnapshot['uidPatient'];
  }

  Map<String, dynamic> toMap(uidAccount, uidNutritionist) {
    Map<String, dynamic> map() {
      return {
        'uidAccount': uidAccount,
        'patient': _patient,
        'gender': _gender,
        'age': _age,
        'phone': _phone,
        'address': _address,
        'cpf': _cpf,
        'email': _email,
        'codePatient': _codePatient,
        'typeUser': "patient",
        'photo': _photo,
        'lastschedule': _lastschedule,
        'nameNutritionist': _nameNutritionist,
        'crnNutritionist': _crnNutritionist,
        'uidNutritionist': uidNutritionist,
        'uidPatient': _uidPatient,
      };
    }

    return map();
  }

  String get uidPatient => _uidPatient!;
  set uidPatient(String? value) {
    _uidPatient = value;
  }

  String get cpf => _cpf!;
  set cpf(String? value) {
    _cpf = value;
  }

  String get nameNutritionist => _nameNutritionist!;
  set nameNutritionist(String? value) {
    _nameNutritionist = value;
  }

  String get crnNutritionist => _crnNutritionist!;
  set crnNutritionist(String? value) {
    _crnNutritionist = value;
  }

  String get lastschedule => _lastschedule!;
  set lastschedule(String? value) {
    _lastschedule = value;
  }

  String get photo => _photo!;
  set photo(String? value) {
    _photo = value;
  }

  String get typeUser => _typeUser!;
  set typeUser(String value) {
    _typeUser = value;
  }

  String get uidAccount => _uidAccount!;
  set uidAccount(String value) {
    _uidAccount = value;
  }

  String get uidNutritionistPatient => _uidNutritionist!;
  set uidNutritionistPatient(String value) {
    _uidNutritionist = value;
  }

  String get codePatient => _codePatient!;

  set codePatient(String value) {
    _codePatient = value;
  }

  String get email => _email!;

  set email(String value) {
    _email = value;
  }

  String get address => _address!;

  set address(String value) {
    _address = value;
  }

  String get phone => _phone!;

  set phone(String value) {
    _phone = value;
  }

  String get age => _age!;

  set age(String value) {
    _age = value;
  }

  String get gender => _gender!;

  set gender(String value) {
    _gender = value;
  }

  String get patient => _patient!;

  set patient(String value) {
    _patient = value;
  }
}
