import 'package:frontend/services/firestore_data_source.dart';
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
  final FirestoreDataSource cloud;
  static const uuid = Uuid();

  LocalPredictionRepository(this._localDataSource, this.cloud);

  @override
  Future<List<Prediction>> getAllPredictions() async{
    final localList =  await _localDataSource.getAllPredictions();
    return localList.isNotEmpty ? localList : await  cloud.getAllPredictions();
  }

  @override
  Future<void> savePrediction(Prediction prediction) async{
    await _localDataSource.savePrediction(prediction);
    try {
      await cloud.savePrediction(prediction);
    } catch (_) {
      // ignore: offline ou erreur réseau
      // todo : ajouter à une file d'attente de synchronisation
    }
  }

  @override
  Future<void> deletePrediction(String id) async{
    await _localDataSource.deletePrediction(id);
    try {
      await cloud.deletePrediction(id);
    } catch (_) {}
    
  }

  @override
  Future<void> clearAllPredictions() async {
    await _localDataSource.clearAllPredictions();
    try {
      await cloud.clearAllPredictions();
    } catch (_) {}
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
