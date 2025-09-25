import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_food_screen/models/profile_food_model.dart';

class AlimentoService {
  static Future<List<Alimento>> carregarAlimentos() async {
    try {
      final String response = await rootBundle.loadString(
        'images/tabela_taco.json',
      );

      final List<dynamic> data = await json.decode(response);

      return data.map((json) => Alimento.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Falha ao carregar os alimentos: $e');
    }
  }
}
