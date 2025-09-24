import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileInfosService {
  static List<String> listStates() {
    List<String> states = [
      'Acre',
      'Alagoas',
      'Amapá',
      'Amazonas',
      'Bahia',
      'Ceará',
      'Distrito Federal',
      'Espírito Santo',
      'Goiás',
      'Maranhão',
      'Mato Grosso',
      'Mato Grosso do Sul',
      'Minas Gerais',
      'Pará',
      'Paraíba',
      'Paraná',
      'Pernambuco',
      'Piauí',
      'Rio de Janeiro',
      'Rio Grande do Norte',
      'Rio Grande do Sul',
      'Rondônia',
      'Roraima',
      'Santa Catarina',
      'São Paulo',
      'Sergipe',
      'Tocantins',
    ];
    return states;
  }

  static List<String> listCare() {
    List<String> care = ['Online', 'Presencial', 'Online/Presencial'];
    return care;
  }

  static List<String> listService() {
    List<String> care = [
      'Clinica',
      'Hospitalar',
      'Esportiva',
      'Coletiva',
      'Estética',
      'Outros',
    ];
    return care;
  }

  static updateInfos(
    BuildContext context,
    String uid,
    String phone,
    String address,
    String state,
    String care,
    List<String> services,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> dataUpdate = {
      'phone': phone,
      'address': address,
      'state': state,
      'care': care,
      'service': services,
    };

    await firestore
        .collection('Nutritionists')
        .doc(uid)
        .update(dataUpdate)
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Informações atualizadas com sucesso!'),
              backgroundColor: MyColors.myPrimary,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context);
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao atualizar informações: $error'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        });

    await prefs.setString('phone', phone);
    await prefs.setString('address', address);
    await prefs.setString('state', state);
    await prefs.setString('care', care);
    await prefs.setStringList('service', services);
  }
}
