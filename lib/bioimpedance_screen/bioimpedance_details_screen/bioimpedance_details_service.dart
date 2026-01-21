import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class BioimpedanceDetailsService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static Future<void> deleteImageAndUpdate({
    required String uidBioimpedance,
    required String imageUrl,
  }) async {
    // Remove image from Storage
    await storage.refFromURL(imageUrl).delete();

    // Remove URL from Firestore array and update date
    await firestore.collection('Bioimpedance').doc(uidBioimpedance).update({
      'bioimpedanceImages': FieldValue.arrayRemove([imageUrl]),
      'bioimpedanceUpdatedAt': DateFormat('dd/MM/yyyy').format(DateTime.now()),
    });
  }
}
