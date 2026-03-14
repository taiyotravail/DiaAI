import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/prediction.dart';

class FirestoreDataSource {
  final FirebaseFirestore _firestore;

  FirestoreDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _predictions =>
      _firestore.collection('predictions');

  Future<List<Prediction>> getAllPredictions() async {
    try {
      final snapshot = await _predictions.get();

      final predictions = snapshot.docs
          .map((doc) => Prediction.fromJson(doc.data()))
          .toList();

      predictions.sort((a, b) => b.dateCreation.compareTo(a.dateCreation));
      return predictions;
    } catch (e) {
      throw Exception('Erreur Firestore lecture: $e');
    }
  }

  Future<void> savePrediction(Prediction prediction) async {
    try {
      await _predictions.doc(prediction.id).set(prediction.toJson());
    } catch (e) {
      throw Exception('Erreur Firestore ajout: $e');
    }
  }

  Future<void> deletePrediction(String id) async {
    try {
      await _predictions.doc(id).delete();
    } catch (e) {
      throw Exception('Erreur Firestore suppression: $e');
    }
  }

  Future<void> clearAllPredictions() async {
    try {
      final snapshot = await _predictions.get();
      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Erreur Firestore effacement: $e');
    }
  }
}