import 'package:cloud_firestore/cloud_firestore.dart';

class DBCreateAccountNutritionist {
  String? _uid;
  String? _nameNutritionist;
  String? _cpf;
  String? _crn;
  String? _state;
  List<String>? _service;
  String? _care;
  String? _address;
  String? _phone;
  String? _typeUser = "Nutritionist";

  DBCreateAccountNutritionist();

  DBCreateAccountNutritionist.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    uid = documentSnapshot["uid"];
    nameNutritionist = documentSnapshot["nameNutritionist"];
    cpf = documentSnapshot["cpf"];
    crn = documentSnapshot["crn"];
    state = documentSnapshot["state"];
    service = List<String>.from(documentSnapshot["service"]);
    care = documentSnapshot["care"];
    address = documentSnapshot["address"];
    phone = documentSnapshot["phone"];
    typeUser = documentSnapshot["typeUser"];
  }

  Map<String, dynamic> toMap(uid) {
    Map<String, dynamic> map() {
      return {
        'uid': uid,
        'nameNutritionist': _nameNutritionist,
        'cpf': _cpf,
        'crn': _crn,
        'state': _state,
        'service': _service,
        'care': _care,
        'address': _address,
        'phone': _phone,
        'typeUser': _typeUser,
      };
    }

    return map();
  }

  String get uid => _uid!;
  set uid(String? value) => _uid = value;

  String get nameNutritionist => _nameNutritionist!;
  set nameNutritionist(String value) => _nameNutritionist = value;

  String get cpf => _cpf!;
  set cpf(String value) => _cpf = value;

  String get crn => _crn!;
  set crn(String value) => _crn = value;

  String get state => _state!;
  set state(String value) => _state = value;

  List<String> get service => _service!;
  set service(List<String>? value) => _service = value;

  String get care => _care!;
  set care(String value) => _care = value;

  String get address => _address!;
  set address(String value) => _address = value;

  String get phone => _phone!;
  set phone(String value) => _phone = value;

  String get typeUser => _typeUser!;
  set typeUser(String value) => _typeUser = value;
}
