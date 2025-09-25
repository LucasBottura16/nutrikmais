import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_services_screen/models/profile_services_model.dart';
import 'package:nutrikmais/utils/random_key.dart';

class ProfileServicesService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<Stream<QuerySnapshot>?>? addListenerService(
    StreamController<QuerySnapshot> controllerStream,
  ) async {
    Stream<QuerySnapshot> stream = firestore
        .collection("Nutritionists")
        .doc(auth.currentUser?.uid)
        .collection("Services")
        .snapshots();

    stream.listen((event) {
      controllerStream.add(event);
    });

    return null;
  }

  Future<void> addServicesNutritionist(
    String uidNutritionist,
    String nameService,
    String descriptionService,
    String priceService,
  ) async {
    DBServiceModel dbServiceModel = DBServiceModel();
    String uid = RandomKeys().generateRandomString();

    dbServiceModel.uidNutritionist = uidNutritionist;
    dbServiceModel.nameService = nameService;
    dbServiceModel.descriptionService = descriptionService;
    dbServiceModel.priceService = priceService;

    await firestore
        .collection("Nutritionists")
        .doc(uidNutritionist)
        .collection("Services")
        .doc(uid)
        .set(dbServiceModel.toMap(uid));
  }

  Future<void> deleteService(String uidNutritionist, String uidService) async {
    await firestore
        .collection("Nutritionists")
        .doc(uidNutritionist)
        .collection("Services")
        .doc(uidService)
        .delete();
  }
}
