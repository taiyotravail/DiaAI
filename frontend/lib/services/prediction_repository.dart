import 'package:uuid/uuid.dart';
import '../models/prediction.dart';
import 'local_data_source.dart';

/// Repository pour gérer les prédictions
/// Permet de basculer entre LocalDataSource et future SQLDataSource (Pattern Repository)
abstract class PredictionRepository {
  Future<List<Prediction>> getAllPredictions();
  Future<void> savePrediction(Prediction prediction);
  Future<void> deletePrediction(String id);
  Future<void> clearAllPredictions();
}

/// Implémentation du Repository avec stockage local
class LocalPredictionRepository implements PredictionRepository {
  final LocalDataSource _localDataSource;
  static const uuid = Uuid();

  LocalPredictionRepository(this._localDataSource);

  @override
  Future<List<Prediction>> getAllPredictions() {
    return _localDataSource.getAllPredictions();
  }

  @override
  Future<void> savePrediction(Prediction prediction) {
    return _localDataSource.savePrediction(prediction);
  }

  @override
  Future<void> deletePrediction(String id) {
    return _localDataSource.deletePrediction(id);
  }

  @override
  Future<void> clearAllPredictions() {
    return _localDataSource.clearAllPredictions();
  }

  /// Créer et sauvegarder une nouvelle prédiction
  Future<Prediction> createAndSavePrediction({
    required double glycemieAvant,
    required double glucides,
    required double insuline,
    required double glycemiePredite,
  }) async {
    final prediction = Prediction(
      id: uuid.v4(),
      glycemieAvant: glycemieAvant,
      glucides: glucides,
      insuline: insuline,
      glycemiePredite: glycemiePredite,
      dateCreation: DateTime.now(),
    );

    await savePrediction(prediction);
    return prediction;
  }
}
