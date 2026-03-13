import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/services/local_data_source.dart';
import 'package:frontend/services/prediction_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Si j'utilise SharedPreferences ou un plugin natif dans mon test, il faut initialiser le binding pour éviter les erreurs
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalPredictionRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final dataSource = LocalDataSource(prefs);
    repository = LocalPredictionRepository(dataSource);
  });

  test('Repository: au debut la liste est vide', () async {
    final all = await repository.getAllPredictions();
    expect(all, isEmpty);
  });

  test('Repository: creer deux predictions donne deux ids differents', () async {
    final p1 = await repository.createAndSavePrediction(
      glycemieAvant: 1.0,
      glucides: 30.0,
      insuline: 2.0,
      glycemiePredite: 1.2,
    );

    final p2 = await repository.createAndSavePrediction(
      glycemieAvant: 1.1,
      glucides: 40.0,
      insuline: 3.0,
      glycemiePredite: 1.3,
    );

    final all = await repository.getAllPredictions();

    expect(all.length, 2);
    expect(p1.id, isNot(p2.id));
  });

  test('Repository: supprimer une prediction la retire bien', () async {
    final created = await repository.createAndSavePrediction(
      glycemieAvant: 1.1,
      glucides: 55.0,
      insuline: 5.0,
      glycemiePredite: 1.4,
    );

    await repository.deletePrediction(created.id);
    final all = await repository.getAllPredictions();

    expect(all, isEmpty);
  });

  test('Repository: clearAllPredictions vide tout', () async {
    await repository.createAndSavePrediction(
      glycemieAvant: 1.1,
      glucides: 55.0,
      insuline: 5.0,
      glycemiePredite: 1.4,
    );

    await repository.clearAllPredictions();
    final all = await repository.getAllPredictions();

    expect(all, isEmpty);
  });
}