import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/prediction.dart';

void main() {
  test('toJson puis fromJson garde tous les champs', () {
    final prediction = Prediction(
      id: 'id-123',
      glycemieAvant: 1.02,
      glucides: 45.0,
      insuline: 3.0,
      glycemiePredite: 1.34,
      dateCreation: DateTime.parse('2026-03-12T10:00:00.000Z'),
    );

    final rebuilt = Prediction.fromJson(prediction.toJson());

    expect(rebuilt.id, prediction.id);
    expect(rebuilt.glycemieAvant, prediction.glycemieAvant);
    expect(rebuilt.glucides, prediction.glucides);
    expect(rebuilt.insuline, prediction.insuline);
    expect(rebuilt.glycemiePredite, prediction.glycemiePredite);
    expect(rebuilt.dateCreation, prediction.dateCreation);
  });

  test('fromJson avec un champ manquant lance une erreur', () {
    final jsonSansId = {
      'glycemieAvant': 1.0,
      'glucides': 25.0,
      'insuline': 2.0,
      'glycemiePredite': 1.2,
      'dateCreation': '2026-03-12T10:00:00.000Z',
    };

    expect(() => Prediction.fromJson(jsonSansId), throwsA(anything));
  });
}