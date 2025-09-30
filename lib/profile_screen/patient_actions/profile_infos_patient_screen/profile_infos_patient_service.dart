import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileInfosPatientService {
  static updateInfosPatient(
    BuildContext context,
    String uid,
    String phone,
    String address,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> dataUpdate = {'phone': phone, 'address': address};

    await firestore
        .collection('Patients')
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
  }
}
