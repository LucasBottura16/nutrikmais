import 'package:cloud_firestore/cloud_firestore.dart';

class DBServiceModel {
  String? _uidService;
  String? _uidNutritionist;
  String? _nameService;
  String? _descriptionService;
  String? _priceService;

  DBServiceModel();

  DBServiceModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    uidService = documentSnapshot["uidService"];
    uidNutritionist = documentSnapshot["uidNutritionist"];
    nameService = documentSnapshot["nameService"];
    descriptionService = documentSnapshot["descriptionService"];
    priceService = documentSnapshot["priceService"];
  }

  Map<String, dynamic> toMap(uid) {
    Map<String, dynamic> map() {
      return {
        "uidService": uid,
        "uidNutritionist": _uidNutritionist,
        "nameService": _nameService,
        "descriptionService": _descriptionService,
        "priceService": _priceService,
      };
    }

    return map();
  }

  String get uidService => _uidService!;
  set uidService(String? value) => _uidService = value;

  String get uidNutritionist => _uidNutritionist!;
  set uidNutritionist(String? value) => _uidNutritionist = value;

  String get nameService => _nameService!;
  set nameService(String? value) => _nameService = value;

  String get descriptionService => _descriptionService!;
  set descriptionService(String? value) => _descriptionService = value;

  String get priceService => _priceService!;
  set priceService(String? value) => _priceService = value;
}
