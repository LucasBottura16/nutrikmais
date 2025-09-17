import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> addCatalog(
    String catalogImage,
    String catalogName,
    String typeuser,
    String uid,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? imageUrl = await uploadImages(catalogImage, catalogName, uid);

    if (typeuser == "nutritionist") {
      await firestore
          .collection("Nutritionists")
          .doc(uid)
          .update({"photo": imageUrl})
          .then((value) => prefs.setString("photoLogged", imageUrl ?? "null"));
    } else if (typeuser == "patient") {
      await firestore
          .collection("Patients")
          .doc(uid)
          .update({"photo": imageUrl})
          .then((value) => prefs.setString("photoLogged", imageUrl ?? "null"));
    }
  }

  static Future<String?> uploadImages(
    String picker,
    String title,
    String uid,
  ) async {
    if (picker == "Sem Imagem" || picker.isEmpty) {
      debugPrint("Sem Imagem");
      return null;
    }

    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference raiz = storage.ref();
      final Reference file = raiz
          .child("Pefils")
          .child(uid)
          .child("$title.png");

      if (kIsWeb) {
        final XFile image = XFile(picker);
        final bytes = await image.readAsBytes();
        final UploadTask uploadTask = file.putData(bytes);
        final TaskSnapshot taskSnapshot = await uploadTask;
        return await taskSnapshot.ref.getDownloadURL();
      } else {
        final File imageFile = File(picker);
        final UploadTask uploadTask = file.putFile(imageFile);
        final TaskSnapshot taskSnapshot = await uploadTask;
        return await taskSnapshot.ref.getDownloadURL();
      }
    } catch (e) {
      debugPrint("Erro ao fazer upload da imagem: $e");
      return null;
    }
  }
}
