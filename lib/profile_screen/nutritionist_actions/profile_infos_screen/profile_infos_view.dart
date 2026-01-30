import 'package:flutter/material.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_infos_screen/profile_infos_service.dart';
import 'package:nutrikmais/globals/customs/Widgets/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs/components/custom_button.dart';
import 'package:nutrikmais/globals/customs/components/custom_dropdown.dart';
import 'package:nutrikmais/globals/customs/components/custom_input_field.dart';
import 'package:nutrikmais/globals/customs/components/customs_multidropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileInfosView extends StatefulWidget {
  const ProfileInfosView({super.key});

  @override
  State<ProfileInfosView> createState() => _ProfileInfosViewState();
}

class _ProfileInfosViewState extends State<ProfileInfosView> {
  final TextEditingController _controllerPhoneNutri = TextEditingController();
  final TextEditingController _controllerAddressNutri = TextEditingController();

  String _nameNutri = "";
  String _crnNutri = "";
  String _cpfNutri = "";
  String _uid = "";
  String? _selectedState;
  String? _selectedCare;
  List<String> _selectedService = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final name = prefs.getString('nameLogged') ?? '';
    final crn = prefs.getString('crnNutritionist') ?? '';
    final phone = prefs.getString('phone') ?? '';
    final address = prefs.getString('address') ?? '';
    final state = prefs.getString('state') ?? '';
    final cpf = prefs.getString('cpf') ?? '';
    final care = prefs.getString('care') ?? '';
    final services = prefs.getStringList('service') ?? [];
    final uidValue = prefs.getString('uidLogged') ?? "";

    setState(() {
      _nameNutri = name;
      _crnNutri = crn;
      _cpfNutri = cpf;
      _uid = uidValue;

      _controllerPhoneNutri.text = phone;
      _controllerAddressNutri.text = address;
      _selectedState = state.isNotEmpty ? state : null;
      _selectedCare = care.isNotEmpty ? care : null;
      _selectedService = services;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Info. Nutricionista',
        backgroundColor: MyColors.myPrimary,
      ),
      // Usa um operador ternário para mostrar o loading ou o conteúdo
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informações do Nutricionista',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Nome:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(_nameNutri, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    const Text(
                      'CRN:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(_crnNutri, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    const Text(
                      'CPF:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(_cpfNutri, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    CustomInputField(
                      controller: _controllerPhoneNutri,
                      labelText: 'Telefone',
                    ),
                    const SizedBox(height: 10),
                    CustomInputField(
                      controller: _controllerAddressNutri,
                      labelText: 'Endereço',
                    ),
                    const SizedBox(height: 10),
                    CustomDropdown<String>(
                      value: _selectedState,
                      hintText: 'Escolha um estado',
                      items: ProfileInfosService.listStates(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedState = newValue;
                        });
                      },
                      labelText: 'ESTADO',
                    ),
                    const SizedBox(height: 10),
                    CustomDropdown<String>(
                      value: _selectedCare,
                      hintText: 'Escolha um tipo de atuação',
                      items: ProfileInfosService.listCare(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCare = newValue;
                        });
                      },
                      labelText: 'TIPOS DE ATUAÇÃO',
                    ),
                    const SizedBox(height: 10),
                    CustomMultiSelectDropdown<String>(
                      hintText: 'Areas de atendimento',
                      labelText: 'ÁREAS DE ATENDIMENTO',
                      items: ProfileInfosService.listService(),
                      value: _selectedService,
                      selectItemfinal: _selectedService,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedService = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        ProfileInfosService.updateInfos(
                          context,
                          _uid,
                          _controllerPhoneNutri.text,
                          _controllerAddressNutri.text,
                          _selectedState ?? '',
                          _selectedCare ?? '',
                          _selectedService,
                        );
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      title: "ATUALIZAR INFORMAÇÕES",
                      titleColor: Colors.white,
                      titleSize: 16,
                      buttonEdgeInsets: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      buttonColor: MyColors.myPrimary,
                      buttonBorderRadius: 10,
                      loadingColor: MyColors.myPrimary,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
