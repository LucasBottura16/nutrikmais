import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeService {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<void> getMyDetails() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userUid = auth.currentUser!.uid;

    try {
      final nutritionistDoc = await firestore
          .collection("Nutritionists")
          .doc(userUid)
          .get();

      if (nutritionistDoc.exists && nutritionistDoc.data() != null) {
        await _details(nutritionistDoc, "nutritionist");
        return;
      }

      final patientQuery = await firestore
          .collection("Patients")
          .where("uidPatient", isEqualTo: userUid)
          .get();

      if (patientQuery.docs.isNotEmpty) {
        final patientDoc = patientQuery.docs.first;
        await _details(patientDoc, "patient");
        return;
      }

      debugPrint(
        "Usuário não encontrado nas coleções Nutritionists ou Patients",
      );
    } catch (e) {
      debugPrint("Erro ao buscar detalhes do usuário: $e");
    }
  }

  static Future<void> _details(
    DocumentSnapshot myDetails,
    String userType,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var details = myDetails.data() as Map<String, dynamic>;

      debugPrint("Detalhes do usuário: $details");
      debugPrint("Tipo de usuário: $userType");

      switch (userType) {
        case "nutritionist":
          prefs.setString("uidLogged", details["uid"] ?? "");
          prefs.setString("nameLogged", details["nameNutritionist"] ?? "");
          prefs.setString("photoLogged", details["photo"] ?? "");
          prefs.setString("crnNutritionist", details["crn"] ?? "");
          prefs.setString("cpf", details["cpf"] ?? "");
          prefs.setString("state", details["state"] ?? "");
          prefs.setString("address", details["address"] ?? "");
          prefs.setString("phone", details["phone"] ?? "");
          prefs.setString("care", details["care"] ?? "");

          List<String> serviceList = [];

          final dynamic serviceValue = details['service'];

          if (serviceValue is List) {
            serviceList = serviceValue.cast<String>();
          } else if (serviceValue is String) {
            serviceList = serviceValue.split(',').map((s) => s.trim()).toList();
          }
          await prefs.setStringList("service", serviceList);

          prefs.setString("typeUser", details["typeUser"]);
          break;
        case "patient":
          prefs.setString("uidLogged", details["uidPatient"] ?? "");
          prefs.setString("nameLogged", details["patient"] ?? "");
          prefs.setString("photoLogged", details["photo"] ?? "");
          prefs.setString("uidNutritionist", details["uidNutritionist"] ?? "");
          prefs.setString("patient", details["patient"] ?? "");
          prefs.setString("age", details["age"] ?? "");
          prefs.setString("cpf", details["cpf"] ?? "");
          prefs.setString("gender", details["gender"] ?? "");
          prefs.setString("address", details["address"] ?? "");
          prefs.setString("codePatient", details["codePatient"] ?? "");
          prefs.setString("phone", details["phone"] ?? "");
          prefs.setString("email", details["email"] ?? "");
          prefs.setString("lastschedule", details["lastschedule"] ?? "");
          prefs.setString("typeUser", details["typeUser"] ?? "");
          prefs.setString("uidAccount", details["uidAccount"] ?? "");
          break;
        default:
          break;
      }
    } catch (e) {
      debugPrint("Erro ao salvar detalhes: $e");
    }
  }
}
