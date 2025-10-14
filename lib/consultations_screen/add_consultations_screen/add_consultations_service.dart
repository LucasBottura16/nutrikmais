import 'package:cloud_firestore/cloud_firestore.dart';
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
}
