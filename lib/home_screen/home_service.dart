import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeService {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<void> getMyDetails() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("Nutritionists")
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) => _details(value));
  }

  static Future<void> _details(DocumentSnapshot? myDetails) async {
    if (myDetails != null && myDetails.data() != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var details = myDetails.data() as Map<String, dynamic>;

      String typeUser = details["typeUser"];

      switch (typeUser) {
        case "nutritionist":
          prefs.setString("nameNutritionist", details["nameNutritionist"]);
          prefs.setString("crnNutritionist", details["crn"]);
          break;
        case "patient":
          prefs.setString("namePatient", details["patient"]);
          prefs.setString("codePatient", details["codePatient"]);
          break;
        default:
          break;
      }
    }
  }
}
