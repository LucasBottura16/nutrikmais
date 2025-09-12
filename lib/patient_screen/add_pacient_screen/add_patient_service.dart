import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/patient_screen/models/patient_model.dart';
import 'package:nutrikmais/utils/random_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPatientService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static List<String> listGender() {
    List<String> gender = ['Masculino', 'Feminino', 'Outro'];
    return gender;
  }

  Future<void> createPatient(
    BuildContext context,
    String patient,
    String gender,
    String age,
    String phone,
    String address,
    String email,
  ) async {
    if (patient.isEmpty ||
        phone.isEmpty ||
        age.isEmpty ||
        gender.isEmpty ||
        address.isEmpty ||
        email.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Erro no cadastro do paciente"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [Text("Preencha todos os campos!")],
            ),
          );
        },
      );
    } else {
      await completedRegister(patient, gender, age, phone, address, email);

      if (!context.mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> completedRegister(
    String patient,
    String gender,
    String age,
    String phone,
    String address,
    String email,
  ) async {
    DBPatientModel patients = DBPatientModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    patients.patient = patient;
    patients.gender = gender;
    patients.age = age;
    patients.phone = phone;
    patients.address = address;
    patients.email = email;
    patients.photo = "null";
    patients.lastschedule = "Ainda não agendado";
    patients.nameNutritionist = prefs.getString('nameNutritionist') ?? '';
    patients.crnNutritionist = prefs.getString('crnNutritionist') ?? '';
    patients.cpf = "";
    patients.uidPatient = "";
    patients.codePatient = RandomKeys().generateRandomCode();

    String uid = RandomKeys().generateRandomString();

    await firestore
        .collection("Patients")
        .doc(uid)
        .set(patients.toMap(uid, auth.currentUser?.uid));
  }
}
