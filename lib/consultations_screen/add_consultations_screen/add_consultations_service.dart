import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrikmais/consultations_screen/models/consultations_model.dart';
import 'package:nutrikmais/utils/random_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddConsultationsService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<String>> getAvailableTimesByDate(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nutritionistUid = prefs.getString('uidLogged');

    try {
      final querySnapshot = await firestore
          .collection('Nutritionists')
          .doc(nutritionistUid)
          .collection('Availability')
          .where('date', isEqualTo: date)
          .where('isScheduled', isEqualTo: false)
          .orderBy('time')
          .get();

      final times = querySnapshot.docs
          .map((d) => d.data()['time'] as String?)
          .where((t) => t != null && t.isNotEmpty)
          .map((t) => t!)
          .toSet()
          .toList();

      times.sort();
      return times;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getServiceTypes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nutritionistUid = prefs.getString('uidLogged');

    try {
      final querySnapshot = await firestore
          .collection('Nutritionists')
          .doc(nutritionistUid)
          .collection('Services')
          .get();

      final serviceTypes = querySnapshot.docs
          .map((d) => d.data()['nameService'] as String?)
          .where((t) => t != null && t.isNotEmpty)
          .map((t) => t!)
          .toSet()
          .toList();

      serviceTypes.sort();
      return serviceTypes;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getServicesWithPrices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nutritionistUid = prefs.getString('uidLogged');

    try {
      final querySnapshot = await firestore
          .collection('Nutritionists')
          .doc(nutritionistUid)
          .collection('Services')
          .get();

      final services = querySnapshot.docs.map((d) {
        final data = d.data();
        return {
          'docId': d.id,
          'nameService': data['nameService'] ?? '',
          'price': data['priceService'] ?? 0,
        };
      }).toList();

      return services;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot>> getPatients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nutritionistUid = prefs.getString('uidLogged');

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection("Patients")
          .where("uidNutritionist", isEqualTo: nutritionistUid)
          .get();

      return querySnapshot.docs;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createConsultation(
    BuildContext context,
    String uidPatient,
    String patient,
    String photo,
    String dateConsultation,
    String timeConsultation,
    String service,
    String price,
    String serviceType,
    String place,
  ) async {
    if (uidPatient.isEmpty ||
        patient.isEmpty ||
        photo.isEmpty ||
        dateConsultation.isEmpty ||
        timeConsultation.isEmpty ||
        service.isEmpty ||
        serviceType.isEmpty ||
        place.isEmpty ||
        price.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Erro ao cadastrar consulta"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [Text("Preencha todos os campos!")],
            ),
          );
        },
      );
    } else {
      await completedRegister(
        uidPatient,
        patient,
        photo,
        dateConsultation,
        timeConsultation,
        service,
        price,
        serviceType,
        place,
      );

      if (!context.mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> completedRegister(
    String uidPatient,
    String patient,
    String photo,
    String dateConsultation,
    String timeConsultation,
    String service,
    String price,
    String serviceType,
    String place,
  ) async {
    DBConsultationsModel consultations = DBConsultationsModel();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String nameNutritionist = prefs.getString('nameLogged') ?? '';
    String uidNutritionist = prefs.getString('uidLogged') ?? '';

    consultations.uidPatient = uidPatient;
    consultations.patient = patient;
    consultations.photo = photo;
    consultations.dateConsultation = dateConsultation;
    consultations.timeConsultation = timeConsultation;
    consultations.serviceType = serviceType;
    consultations.serviceName = service;
    consultations.price = price;
    consultations.status = "Agendada";
    consultations.uidNutritionist = uidNutritionist;
    consultations.nameNutritionist = nameNutritionist;
    consultations.place = place;

    String uidConsultation = RandomKeys().generateRandomString();

    await firestore
        .collection("Consultations")
        .doc(uidConsultation)
        .set(consultations.toMap(uidConsultation));

    try {
      final availQuery = await firestore
          .collection('Nutritionists')
          .doc(uidNutritionist)
          .collection('Availability')
          .where('date', isEqualTo: dateConsultation)
          .where('time', isEqualTo: timeConsultation)
          .limit(1)
          .get();

      if (availQuery.docs.isNotEmpty) {
        final availDoc = availQuery.docs.first;
        await availDoc.reference.update({'isScheduled': true});
      }
    } catch (e) {
      debugPrint('Erro ao marcar disponibilidade como agendada: $e');
    }
  }
}
