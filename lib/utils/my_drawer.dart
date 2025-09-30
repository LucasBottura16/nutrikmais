import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../route_generator.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key, required this.screen});

  final String screen;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late String _currentScreen;
  String _nome = "";
  String _photo = "";
  String _typeUser = "";

  _verifyAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = prefs.getString('nameLogged') ?? '';
      _photo = prefs.getString('photoLogged') ?? '';
      _typeUser = prefs.getString('typeUser') ?? '';
    });
  }

  _singoutAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseAuth auth = FirebaseAuth.instance;

    const List<String> allPossibleKeys = [
      "uidLogged",
      "nameLogged",
      "photoLogged",
      "crnNutritionist",
      "cpf",
      "state",
      "address",
      "phone",
      "care",
      "service",
      "typeUser",
      "uidLogged",
      "nameLogged",
      "photoLogged",
      "nameNutritionist",
      "crnNutritionist",
      "uidNutritionist",
      "patient",
      "age",
      "cpf",
      "gender",
      "address",
      "codePatient",
      "phone",
      "email",
      "lastschedule",
      "typeUser",
      "uidAccount",
    ];

    for (final key in allPossibleKeys) {
      if (prefs.containsKey(key)) {
        await prefs.remove(key);
      }
    }

    await auth.signOut().then(
      (value) => Navigator.pushNamedAndRemoveUntil(
        context,
        RouteGenerator.routeLogin,
        (_) => false,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _currentScreen = widget.screen;
    _verifyAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteGenerator.profileScreen,
                        (_) => false,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: _photo == "null" || _photo == ""
                                  ? Image.asset(
                                      "images/Logo.png",
                                      color: MyColors.myPrimary,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      _photo,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _nome,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "Acessar perfil",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right_outlined,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Card(
                    color: _currentScreen == "home_screen"
                        ? MyColors.myPrimary
                        : Colors.white,
                    child: ListTile(
                      leading: Icon(
                        Icons.home,
                        color: _currentScreen == "home_screen"
                            ? Colors.white
                            : MyColors.myPrimary,
                      ),
                      title: Text(
                        'Inicio',
                        style: TextStyle(
                          color: _currentScreen == "home_screen"
                              ? Colors.white
                              : MyColors.myPrimary,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteGenerator.home,
                          (_) => false,
                        );
                      },
                    ),
                  ),
                  if (_typeUser == "nutritionist")
                    Card(
                      color: _currentScreen == "patient_screen"
                          ? MyColors.myPrimary
                          : Colors.white,
                      child: ListTile(
                        leading: Icon(
                          Icons.person_pin,
                          color: _currentScreen == "patient_screen"
                              ? Colors.white
                              : MyColors.myPrimary,
                        ),
                        title: Text(
                          'Pacientes',
                          style: TextStyle(
                            color: _currentScreen == "patient_screen"
                                ? Colors.white
                                : MyColors.myPrimary,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteGenerator.patientScreen,
                            (_) => false,
                          );
                        },
                      ),
                    ),
                  Card(
                    color: _currentScreen == "consults_screen"
                        ? MyColors.myPrimary
                        : Colors.white,
                    child: ListTile(
                      leading: Icon(
                        Icons.calendar_month,
                        color: _currentScreen == "consults_screen"
                            ? Colors.white
                            : MyColors.myPrimary,
                      ),
                      title: Text(
                        'Consultas',
                        style: TextStyle(
                          color: _currentScreen == "consults_screen"
                              ? Colors.white
                              : MyColors.myPrimary,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  Card(
                    color: _currentScreen == "food_plan_screem"
                        ? MyColors.myPrimary
                        : Colors.white,
                    child: ListTile(
                      leading: Icon(
                        Icons.fastfood,
                        color: _currentScreen == "food_plan_screem"
                            ? Colors.white
                            : MyColors.myPrimary,
                      ),
                      title: Text(
                        'Plano Alimentar',
                        style: TextStyle(
                          color: _currentScreen == "food_plan_screem"
                              ? Colors.white
                              : MyColors.myPrimary,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  Card(
                    color: _currentScreen == "bioimpedance_screen"
                        ? MyColors.myPrimary
                        : Colors.white,
                    child: ListTile(
                      leading: Icon(
                        Icons.biotech,
                        color: _currentScreen == "bioimpedance_screen"
                            ? Colors.white
                            : MyColors.myPrimary,
                      ),
                      title: Text(
                        'Bioimpedância',
                        style: TextStyle(
                          color: _currentScreen == "bioimpedance_screen"
                              ? Colors.white
                              : MyColors.myPrimary,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteGenerator.routeLogin,
                          (_) => false,
                        );
                      },
                    ),
                  ),
                  Card(
                    color: _currentScreen == "orientations_screen"
                        ? MyColors.myPrimary
                        : Colors.white,
                    child: ListTile(
                      leading: Icon(
                        Icons.note_alt_sharp,
                        color: _currentScreen == "orientations_screen"
                            ? Colors.white
                            : MyColors.myPrimary,
                      ),
                      title: Text(
                        'Orientações',
                        style: TextStyle(
                          color: _currentScreen == "orientations_screen"
                              ? Colors.white
                              : MyColors.myPrimary,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  Card(
                    color: _currentScreen == "Evolution_screen"
                        ? MyColors.myPrimary
                        : Colors.white,
                    child: ListTile(
                      leading: Icon(
                        Icons.accessibility_new_outlined,
                        color: _currentScreen == "Evolution_screen"
                            ? Colors.white
                            : MyColors.myPrimary,
                      ),
                      title: Text(
                        'Evolução',
                        style: TextStyle(
                          color: _currentScreen == "Evolution_screen"
                              ? Colors.white
                              : MyColors.myPrimary,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              Card(
                color: MyColors.myPrimary,
                child: ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.white),
                  title: const Text(
                    'Sair',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _singoutAccount();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
