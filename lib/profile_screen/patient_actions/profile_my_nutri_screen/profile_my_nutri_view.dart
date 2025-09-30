import 'package:flutter/material.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileMyNutriView extends StatefulWidget {
  const ProfileMyNutriView({super.key});

  @override
  State<ProfileMyNutriView> createState() => _ProfileMyNutriViewState();
}

class _ProfileMyNutriViewState extends State<ProfileMyNutriView> {
  String _nameNutri = "";
  String _crnNutri = "";
  String _phoneNutri = "";

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final name = prefs.getString('nameNutritionist') ?? '';
    final crn = prefs.getString('crnNutritionist') ?? '';
    final phone = prefs.getString('phoneNutritionist') ?? '';

    setState(() {
      _nameNutri = name;
      _crnNutri = crn;
      _phoneNutri = phone;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Info. do Nutricionista',
        backgroundColor: MyColors.myPrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome: $_nameNutri',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text('CRN: $_crnNutri', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    'Telefone: $_phoneNutri',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
    );
  }
}
