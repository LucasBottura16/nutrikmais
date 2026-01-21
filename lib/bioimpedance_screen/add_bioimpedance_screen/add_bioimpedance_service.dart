import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrikmais/bioimpedance_screen/models/bioimpedance_model.dart';
import 'package:nutrikmais/utils/random_key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class AddBioimpedanceService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<QueryDocumentSnapshot>> getScheduledConsultations() async {
    try {
      final querySnapshot = await firestore
          .collection('Consultations')
          .where('uidNutritionist', isEqualTo: auth.currentUser?.uid)
          .where('status', isEqualTo: 'Agendada')
          .orderBy('dateConsultation')
          .orderBy('timeConsultation')
          .get();

      return querySnapshot.docs;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<String>> uploadBioimpedanceImages(
    List<String> imagePaths,
    String uidPatient,
    String uidBioimpedance,
  ) async {
    List<String> downloadUrls = [];

    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference raiz = storage.ref();

      for (int i = 0; i < imagePaths.length; i++) {
        final imagePath = imagePaths[i];
        final Reference file = raiz
            .child("Bioimpedance")
            .child(uidPatient)
            .child("${uidBioimpedance}_$i.png");

        try {
          if (kIsWeb) {
            final XFile image = XFile(imagePath);
            final bytes = await image.readAsBytes();
            final UploadTask uploadTask = file.putData(bytes);
            final TaskSnapshot taskSnapshot = await uploadTask;
            final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
            downloadUrls.add(downloadUrl);
          } else {
            final File imageFile = File(imagePath);
            final UploadTask uploadTask = file.putFile(imageFile);
            final TaskSnapshot taskSnapshot = await uploadTask;
            final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
            downloadUrls.add(downloadUrl);
          }
        } catch (e) {
          debugPrint("Erro ao fazer upload da imagem $i: $e");
        }
      }

      return downloadUrls;
    } catch (e) {
      debugPrint("Erro ao fazer upload das imagens: $e");
      return [];
    }
  }

  Future<void> completedRegister(
    String uidPatient,
    String patient,
    List<String>? bioimpedanceImages,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uidNutritionist = prefs.getString('uidLogged') ?? '';

      String uidBioimpedance = RandomKeys().generateRandomString();

      // Upload das imagens para o Firebase Storage
      List<String> imageUrls = [];
      if (bioimpedanceImages != null && bioimpedanceImages.isNotEmpty) {
        imageUrls = await uploadBioimpedanceImages(
          bioimpedanceImages,
          uidPatient,
          uidBioimpedance,
        );
      }

      DBBioimpedance bioimpedanceData = DBBioimpedance();
      bioimpedanceData.uidPatient = uidPatient;
      bioimpedanceData.patientName = patient;
      bioimpedanceData.uidNutritionist = uidNutritionist;
      bioimpedanceData.bioimpedanceUpdatedAt = DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.now());
      bioimpedanceData.bioimpedanceImages = imageUrls;

      // Salvar no Firestore com as URLs das imagens
      await firestore
          .collection("Bioimpedance")
          .doc(uidBioimpedance)
          .set(bioimpedanceData.toMap(uidBioimpedance));
    } catch (e) {
      debugPrint("Erro ao salvar bioimpedância: $e");
      rethrow;
    }
  }
}
