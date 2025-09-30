import 'package:url_launcher/url_launcher.dart';

class ProfileMyNutriService {
  static launchWhatsApp(String phoneNumber, String name) async {
    String cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final url = 'whatsapp://send?phone=55$cleanPhoneNumber&text=Olá,$name!';
    await launchUrl(Uri.parse(url));
  }
}
