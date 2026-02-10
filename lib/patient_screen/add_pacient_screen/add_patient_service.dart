import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/patient_screen/models/patient_model.dart';
import 'package:nutrikmais/utils/age_utils.dart';
import 'package:nutrikmais/utils/random_key.dart';

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
    String birthDate,
    String phone,
    String address,
    String email,
  ) async {
    if (patient.isEmpty ||
        phone.isEmpty ||
        birthDate.isEmpty ||
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
      final int? age = AgeUtils.calculateAgeFromBirthDate(birthDate);

      if (age == null) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Data de nascimento inválida"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [Text("Informe uma data válida (dd/mm/aaaa).")],
              ),
            );
          },
        );
        return;
      }

      await completedRegister(
        patient,
        gender,
        birthDate,
        phone,
        address,
        email,
      );

      if (!context.mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> completedRegister(
    String patient,
    String gender,
    String birthDate,
    String phone,
    String address,
    String email,
  ) async {
    DBPatientModel patients = DBPatientModel();
    patients.patient = patient;
    patients.gender = gender;
    patients.birthDate = birthDate;
    patients.phone = phone;
    patients.address = address;
    patients.email = email;
    patients.photo = "null";
    patients.lastschedule = "Ainda não agendado";
    patients.cpf = "";
    patients.uidPatient = "";
    patients.codePatient = RandomKeys().generateRandomCode();
    patients.stateAccount = "pending";

    String uid = RandomKeys().generateRandomString();

    await firestore
        .collection("Patients")
        .doc(uid)
        .set(patients.toMap(uid, auth.currentUser?.uid));
  }
}
