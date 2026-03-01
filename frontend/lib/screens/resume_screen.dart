import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/prediction_card.dart';

class ResumeScreen extends StatelessWidget {
  const ResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('Résumé'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Dernière prédiction",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            FutureBuilder(
              future: predictionRepository.getAllPredictions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Chargement...");
                }

                if (snapshot.hasError) {
                  return Text("Erreur: ${snapshot.error}");
                }

                final predictions = snapshot.data ?? [];
                if (predictions.isEmpty) {
                  return const Text("Aucune prédiction");
                }
                else {
                  return PredictionCard(
                    prediction: predictions.last
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
