import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileMyNutriService {
  static Future<Map<String, dynamic>> getNutritionistInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final uidNutritionist = prefs.getString('uidNutritionist') ?? '';

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot doc = await firestore
        .collection('Nutritionists')
        .doc(uidNutritionist)
        .get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return {
        'nameNutritionist': data['nameNutritionist'] ?? '',
        'phone': data['phone'] ?? '',
        'crn': data['crn'] ?? '',
      };
    } else {
      return {'nameNutritionist': '', 'phone': '', 'crn': ''};
    }
  }

  static launchWhatsApp(String phoneNumber, String name) async {
    String cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final url = 'whatsapp://send?phone=55$cleanPhoneNumber&text=Olá,$name!';
    await launchUrl(Uri.parse(url));
  }
}
