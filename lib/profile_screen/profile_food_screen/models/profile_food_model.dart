class Alimento {
  final int numero;
  final String categoria;
  final String descricao;
  final String umidade;
  final String energiaKcal;
  final String proteinaG;
  final String lipideosG;
  final String carboidratoG;
  final String fibraAlimentarG;
  final String calcioMg;
  final String sodioMg;
  final String medidaCaseira;

  Alimento({
    required this.numero,
    required this.categoria,
    required this.descricao,
    required this.umidade,
    required this.energiaKcal,
    required this.proteinaG,
    required this.lipideosG,
    required this.carboidratoG,
    required this.fibraAlimentarG,
    required this.calcioMg,
    required this.sodioMg,
    required this.medidaCaseira,
  });

  factory Alimento.fromJson(Map<String, dynamic> json) {
    String asString(dynamic value) => value?.toString() ?? '';

    return Alimento(
      numero: json['numero_do_alimento'] as int,
      categoria: asString(json['categoria']),
      descricao: asString(json['descricao_dos_alimentos']),
      umidade: asString(json['umidade_(%)']),
      energiaKcal: asString(json['energia_(kcal)']),
      proteinaG: asString(json['proteina_(g)']),
      lipideosG: asString(json['lipideos_(g)']),
      carboidratoG: asString(json['carboidrato_(g)']),
      fibraAlimentarG: asString(json['fibra_alimentar_(g)']),
      calcioMg: asString(json['calcio_(mg)']),
      sodioMg: asString(json['sodio_(mg)']),
      medidaCaseira: asString(json['medida_caseira']),
    );
  }
}
