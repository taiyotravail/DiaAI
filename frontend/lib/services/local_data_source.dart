import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prediction.dart';

// Source de données locale pour les prédictions
// Utilise SharedPreferences pour le stockage persistant
class LocalDataSource {
  static const String _key = 'predictions';
  final SharedPreferences _prefs;

  LocalDataSource(this._prefs);

  // Récupérer toutes les prédictions
  Future<List<Prediction>> getAllPredictions() async {
    try {
      final jsonString = _prefs.getString(_key);
      if (jsonString == null) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => Prediction.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la lecture des prédictions: $e');
    }
  }

  // Ajouter une nouvelle prédiction
  Future<void> savePrediction(Prediction prediction) async {
    try {
      final predictions = await getAllPredictions();
      predictions.add(prediction);

      final jsonString = jsonEncode(
        predictions.map((p) => p.toJson()).toList(),
      );

      await _prefs.setString(_key, jsonString);
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la prédiction: $e');
    }
  }

  // Supprimer une prédiction par ID
  Future<void> deletePrediction(String id) async {
    try {
      final predictions = await getAllPredictions();
      predictions.removeWhere((p) => p.id == id);

      final jsonString = jsonEncode(
        predictions.map((p) => p.toJson()).toList(),
      );

      await _prefs.setString(_key, jsonString);
    } catch (e) {
      throw Exception('Erreur lors de la suppression de la prédiction: $e');
    }
  }

  // Effacer toutes les prédictions
  Future<void> clearAllPredictions() async {
    try {
      await _prefs.remove(_key);
    } catch (e) {
      throw Exception('Erreur lors de l\'effacement des prédictions: $e');
    }
  }
}
