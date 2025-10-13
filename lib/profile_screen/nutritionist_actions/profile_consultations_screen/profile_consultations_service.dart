import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultationService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<Stream<QuerySnapshot>?>? addListenerAvailability(
    StreamController<QuerySnapshot> controllerStream,
    String nutritionistUid,
    String date,
  ) async {
    Stream<QuerySnapshot> stream = firestore
        .collection('Nutritionists')
        .doc(nutritionistUid)
        .collection('Availability')
        .where('date', isEqualTo: date)
        .orderBy('time', descending: false)
        .snapshots();

    stream.listen((event) {
      controllerStream.add(event);
    });

    return null;
  }

  Future<void> addAvailability({
    required String nutritionistUid,
    required String date,
    required String time,
  }) async {
    final availability = DateTime.parse(
      '${date.split('/').reversed.join('-')}T$time:00',
    );
    if (availability.isBefore(DateTime.now())) {
      throw Exception('Não é possível cadastrar horários em datas passadas.');
    }

    try {
      final collectionRef = firestore
          .collection('Nutritionists')
          .doc(nutritionistUid)
          .collection('Availability');

      final querySnapshot = await collectionRef
          .where('date', isEqualTo: date)
          .where('time', isEqualTo: time)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Este horário já foi cadastrado.');
      }

      await collectionRef.add({
        'date': date,
        'time': time,
        'isScheduled': false,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeAvailability({
    required String nutritionistUid,
    required String date,
    required String time,
    required bool isScheduled,
  }) async {
    if (isScheduled) {
      throw Exception('Não é possível remover um horário já agendado.');
    }

    try {
      final querySnapshot = await firestore
          .collection('Nutritionists')
          .doc(nutritionistUid)
          .collection('Availability')
          .where('date', isEqualTo: date)
          .where('time', isEqualTo: time)
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
