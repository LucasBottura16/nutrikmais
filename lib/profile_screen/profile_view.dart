import 'package:flutter/material.dart';
import 'package:nutrikmais/profile_screen/profile_service.dart';
import 'package:nutrikmais/route_generator.dart';
import 'package:nutrikmais/globals/configs/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs_components/custom_image_picker.dart';
import 'package:nutrikmais/globals/configs/my_drawer.dart';
import 'package:nutrikmais/globals/hooks/use_user_type.dart';

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
    final userPrefs = await useUserPreferences();
    setState(() {
      _nome = userPrefs.nameLogged;
      _pickerValue = userPrefs.photoLogged;
      _typeUser = userPrefs.typeUser;
      _crnNutritionist = userPrefs.crnNutritionist;
      _phone = userPrefs.phone;
      _uid = userPrefs.typeUser == "nutritionist"
          ? userPrefs.uidLogged
          : userPrefs.uidAccount;
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
                        Icons.person_outline,
                        'Informações pessoais',
                        RouteGenerator.profileInfosPatientScreen,
                      ),
                      Divider(),
                      _buildInfoTile(
                        Icons.assignment,
                        'Dados do nutricionista',
                        RouteGenerator.profileMyNutriScreen,
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
