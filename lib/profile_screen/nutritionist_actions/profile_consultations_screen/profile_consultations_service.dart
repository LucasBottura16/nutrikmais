import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAvailableSlot({
    required String nutritionistUid,
    required DateTime slotTime,
  }) async {
    if (slotTime.isBefore(DateTime.now())) {
      throw Exception('Não é possível cadastrar horários em datas passadas.');
    }

    try {
      final collectionRef = _firestore
          .collection('Nutritionists')
          .doc(nutritionistUid)
          .collection('AvailableSlots');

      final querySnapshot = await collectionRef
          .where('slotTime', isEqualTo: Timestamp.fromDate(slotTime))
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Este horário já foi cadastrado.');
      }

      await collectionRef.add({
        'slotTime': Timestamp.fromDate(slotTime),
        'isBooked': false,
        'patientUid': null,
        'patientName': null,
        'isScheduled': false,
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> getAvailableSlotsStream(
    String nutritionistUid,
  ) {
    return _firestore
        .collection('Nutritionists')
        .doc(nutritionistUid)
        .collection('AvailableSlots')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            final timestamp = data['slotTime'] as Timestamp;
            final isScheduled = data['isScheduled'] ?? false;
            return {'slotTime': timestamp.toDate(), 'isScheduled': isScheduled};
          }).toList();
        });
  }

  Future<void> removeAvailableSlot({
    required String nutritionistUid,
    required DateTime slotTime,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('Nutritionists')
          .doc(nutritionistUid)
          .collection('AvailableSlots')
          .where('slotTime', isEqualTo: Timestamp.fromDate(slotTime))
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
      } else {
        throw Exception('Horário não encontrado para exclusão.');
      }
    } catch (e) {
      throw Exception('Erro ao remover horário: ${e.toString()}');
    }
  }
}
