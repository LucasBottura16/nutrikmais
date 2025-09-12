import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/create_account_screen/models/create_account_model.dart';
import 'package:nutrikmais/patient_screen/models/patient_model.dart';
import 'package:nutrikmais/route_generator.dart';

class CreateAccountService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  Future<void> createNutritionist(
    BuildContext context,
    String email,
    String password,
    String nameNutritionist,
    String cpf,
    String crn,
    String state,
    List<String> service,
    String care,
    String address,
    String phone,
    String typeUser,
  ) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await completedRegisterNutritionist(
        userCredential.user!.uid,
        nameNutritionist,
        cpf,
        crn,
        state,
        service,
        care,
        address,
        phone,
        typeUser,
      );

      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteGenerator.routeLogin,
        (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('A senha fornecida é muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('Já existe uma conta para esse email.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> completedRegisterNutritionist(
    String uid,
    String nameNutritionist,
    String cpf,
    String crn,
    String state,
    List<String> service,
    String care,
    String address,
    String phone,
    String typeUser,
  ) async {
    final DBCreateAccountNutritionist nutritionist =
        DBCreateAccountNutritionist();

    nutritionist.uid = uid;
    nutritionist.nameNutritionist = nameNutritionist;
    nutritionist.cpf = cpf;
    nutritionist.crn = crn;
    nutritionist.state = state;
    nutritionist.service = service;
    nutritionist.care = care;
    nutritionist.address = address;
    nutritionist.phone = phone;
    nutritionist.typeUser = typeUser;

    await firestore
        .collection("Nutritionists")
        .doc(uid)
        .set(nutritionist.toMap(uid));
  }

  Future<void> createPatient(
    BuildContext context,
    String nameNutritionist,
    String crnNutritionist,
    String uidNutritionist,
    String gender,
    String age,
    String codePatient,
    String lastschedule,
    String photo,
    String uidAccount,
    String namePatient,
    String address,
    String phone,
    String cpf,
    String email,
    String password,
    String typeUser,
  ) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await completedRegisterPatient(
        userCredential.user!.uid,
        nameNutritionist,
        crnNutritionist,
        uidNutritionist,
        gender,
        age,
        codePatient,
        lastschedule,
        photo,
        uidAccount,
        namePatient,
        address,
        phone,
        cpf,
        email,
        typeUser,
      );

      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteGenerator.routeLogin,
        (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('A senha fornecida é muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('Já existe uma conta para esse email.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> completedRegisterPatient(
    String uidPatient,
    String nameNutritionist,
    String crnNutritionist,
    String uidNutritionist,
    String gender,
    String age,
    String codePatient,
    String lastschedule,
    String photo,
    String uidAccount,
    String namePatient,
    String address,
    String phone,
    String cpf,
    String email,
    String typeUser,
  ) async {
    final DBPatientModel patient = DBPatientModel();

    debugPrint("iniciou o cadastro do paciente");

    patient.nameNutritionist = nameNutritionist;
    patient.crnNutritionist = crnNutritionist;
    patient.uidPatient = uidPatient;
    patient.patient = namePatient;
    patient.address = address;
    patient.phone = phone;
    patient.cpf = cpf;
    patient.email = email;
    patient.typeUser = typeUser;
    patient.gender = gender;
    patient.age = age;
    patient.codePatient = codePatient;
    patient.photo = photo;
    patient.lastschedule = lastschedule;

    debugPrint("finalizou o cadastro do paciente");

    await firestore
        .collection("Patients")
        .doc(uidAccount)
        .update(patient.toMap(uidAccount, uidNutritionist));

    debugPrint("finalizou o cadastro do paciente no firestore");
  }

  Future validateCode(String code, context) async {
    try {
      final querySnapshot = await firestore
          .collection("Patients")
          .where("codePatient", isEqualTo: code)
          .get();

      return querySnapshot.docs
          .map((doc) => DBPatientModel.fromDocumentSnapshotPatients(doc))
          .first;
    } catch (e) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Erro na validação do código"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [Text("Código inválido!")],
            ),
          );
        },
      );
      return "Erro na validação do código";
    }
  }
}
