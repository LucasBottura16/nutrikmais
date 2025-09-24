import 'package:flutter/material.dart';
import 'package:nutrikmais/profile_screen/profile_service.dart';
import 'package:nutrikmais/route_generator.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:nutrikmais/utils/customs_components/custom_image_picker.dart';
import 'package:nutrikmais/utils/my_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String _crnNutritionist = "";
  String _nome = "";
  String _typeUser = "";
  String _phone = "";
  String _uid = "";

  _verifyAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = prefs.getString('nameLogged') ?? '';
      _pickerValue = prefs.getString('photoLogged') ?? '';
      _typeUser = prefs.getString('typeUser') ?? '';
      _crnNutritionist = prefs.getString('crnNutritionist') ?? '';
      _phone = prefs.getString('phone') ?? '';
      _uid = prefs.getString('typeUser') == "nutritionist"
          ? prefs.getString('uidLogged') ?? ""
          : prefs.getString('uidAccount') ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    _verifyAccount();
  }

  Widget _buildInfoTile(IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }

  String _pickerValue = "Sem Imagem";

  void _setPicker(String imagePath) async {
    setState(() {
      _pickerValue = imagePath;
    });
    await ProfileService.addCatalog(imagePath, _nome, _typeUser, _uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Perfil",
        backgroundColor: MyColors.myPrimary,
      ),
      drawer: MyDrawer(screen: "Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ImageSelectionButton(
                    currentImagePath: _pickerValue,
                    onImageSelected: _setPicker,
                    buttonBackgroundColor: MyColors.myPrimary,
                    borderRadius: 100.0,
                  ),

                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: MyColors.myPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _nome,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(_typeUser == "nutritionist" ? _crnNutritionist : _phone),

            SizedBox(height: 15),

            _typeUser == "nutritionist"
                ? Column(
                    children: [
                      Divider(),
                      _buildInfoTile(
                        Icons.assignment,
                        'Planos de nutricionista',
                        RouteGenerator.profilePlansScreen,
                      ),
                      Divider(),
                      _buildInfoTile(
                        Icons.person_outline,
                        'Informações do nutricionista',
                        RouteGenerator.profileInfosScreen,
                      ),
                      Divider(),
                      _buildInfoTile(
                        Icons.settings,
                        'Serviços',
                        RouteGenerator.profileServicesScreen,
                      ),
                      Divider(),
                      _buildInfoTile(
                        Icons.restaurant_menu,
                        'Alimentos',
                        RouteGenerator.profileFoodScreen,
                      ),
                      Divider(),
                      _buildInfoTile(
                        Icons.calendar_today,
                        'Agendas',
                        RouteGenerator.profileConsultationsScreen,
                      ),
                      Divider(),
                    ],
                  )
                : Column(
                    children: [
                      Divider(),
                      _buildInfoTile(
                        Icons.accessibility_new_outlined,
                        'Evolução',
                        "",
                      ),
                      Divider(),
                      _buildInfoTile(
                        Icons.person_outline,
                        'Informações pessoais',
                        "",
                      ),
                      Divider(),
                      _buildInfoTile(Icons.calendar_today, 'Consultas', ""),
                      Divider(),
                      _buildInfoTile(
                        Icons.restaurant_menu,
                        'Planos Alimentares',
                        "",
                      ),
                      Divider(),
                      _buildInfoTile(Icons.biotech, 'Bioimpedâncias', ""),
                      Divider(),
                      _buildInfoTile(
                        Icons.assignment,
                        'Dados do nutricionista',
                        "",
                      ),
                      Divider(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
