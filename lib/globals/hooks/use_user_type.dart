import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  final String typeUser;
  final String uidAccount;
  final String uidLogged;
  final String nameLogged;
  final String photoLogged;
  final String phone;
  final String crnNutritionist;

  UserPreferences({
    required this.typeUser,
    required this.uidAccount,
    required this.uidLogged,
    required this.nameLogged,
    required this.photoLogged,
    required this.phone,
    required this.crnNutritionist,
  });
}

Future<UserPreferences> useUserPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  
  return UserPreferences(
    typeUser: prefs.getString('typeUser') ?? '',
    uidAccount: prefs.getString('uidAccount') ?? '',
    uidLogged: prefs.getString('uidLogged') ?? '',
    nameLogged: prefs.getString('nameLogged') ?? '',
    photoLogged: prefs.getString('photoLogged') ?? '',
    phone: prefs.getString('phone') ?? '',
    crnNutritionist: prefs.getString('crnNutritionist') ?? '',
  );
}
