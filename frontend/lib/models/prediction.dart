import 'dart:convert';

class Prediction {
  final String id;
  final double glycemieAvant;
  final double glucides;
  final double insuline;
  final double glycemiePredite;
  final DateTime dateCreation;

  Prediction({
    required this.id,
    required this.glycemieAvant,
    required this.glucides,
    required this.insuline,
    required this.glycemiePredite,
    required this.dateCreation,
  });

  // Methode pour convertir une prédiction en JSON pour le stockage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'glycemieAvant': glycemieAvant,
      'glucides': glucides,
      'insuline': insuline,
      'glycemiePredite': glycemiePredite,
      'dateCreation': dateCreation.toIso8601String(),
    };
  }

  // Constructeur pour créer une prédiction à partir de JSON
  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      id: json['id'] as String,
      glycemieAvant: json['glycemieAvant'] as double,
      glucides: json['glucides'] as double,
      insuline: json['insuline'] as double,
      glycemiePredite: json['glycemiePredite'] as double,
      dateCreation: DateTime.parse(json['dateCreation'] as String),
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
