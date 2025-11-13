import 'package:cloud_firestore/cloud_firestore.dart';

class DBConsultationsModel {
  String? _uidConsultation;
  String? _uidPatient;
  String? _patient;
  String? _photo;
  String? _dateConsultation;
  String? _timeConsultation;
  String? _serviceType;
  String? _serviceName;
  String? _price;
  String? _status;
  String? _uidNutritionist;
  String? _nameNutritionist;
  String? _place;

  DBConsultationsModel();

  DBConsultationsModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    uidConsultation = documentSnapshot["uidConsultation"];
    uidPatient = documentSnapshot["uidPatient"];
    patient = documentSnapshot["patient"];
    photo = documentSnapshot["photo"];
    dateConsultation = documentSnapshot["dateConsultation"];
    timeConsultation = documentSnapshot["timeConsultation"];
    serviceType = documentSnapshot["serviceType"];
    serviceName = documentSnapshot["serviceName"];
    price = documentSnapshot["price"];
    status = documentSnapshot["status"];
    uidNutritionist = documentSnapshot["uidNutritionist"];
    nameNutritionist = documentSnapshot["nameNutritionist"];
    place = documentSnapshot["place"];
  }

  Map<String, dynamic> toMap(String uidConsultation) {
    var map = <String, dynamic>{
      'uidConsultation': uidConsultation,
      'uidPatient': uidPatient,
      'patient': patient,
      'photo': photo,
      'dateConsultation': dateConsultation,
      'timeConsultation': timeConsultation,
      'serviceType': serviceType,
      'serviceName': serviceName,
      'price': price,
      'status': status,
      'uidNutritionist': uidNutritionist,
      'nameNutritionist': nameNutritionist,
      'place': place,
    };
    return map;
  }

  String? get place => _place!;
  set place(String? value) {
    _place = value;
  }

  String? get serviceName => _serviceName!;
  set serviceName(String? value) {
    _serviceName = value;
  }

  String? get uidConsultation => _uidConsultation!;
  set uidConsultation(String? value) {
    _uidConsultation = value;
  }

  String? get uidPatient => _uidPatient!;
  set uidPatient(String? value) {
    _uidPatient = value;
  }

  String? get patient => _patient!;
  set patient(String? value) {
    _patient = value;
  }

  String? get photo => _photo!;
  set photo(String? value) {
    _photo = value;
  }

  String? get dateConsultation => _dateConsultation!;
  set dateConsultation(String? value) {
    _dateConsultation = value;
  }

  String? get timeConsultation => _timeConsultation!;
  set timeConsultation(String? value) {
    _timeConsultation = value;
  }

  String? get serviceType => _serviceType!;
  set serviceType(String? value) {
    _serviceType = value;
  }

  String? get price => _price!;
  set price(String? value) {
    _price = value;
  }

  String? get status => _status!;
  set status(String? value) {
    _status = value;
  }

  String? get uidNutritionist => _uidNutritionist!;
  set uidNutritionist(String? value) {
    _uidNutritionist = value;
  }

  String? get nameNutritionist => _nameNutritionist!;
  set nameNutritionist(String? value) {
    _nameNutritionist = value;
  }
}
