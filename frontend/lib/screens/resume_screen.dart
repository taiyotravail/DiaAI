import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/prediction_card.dart';
import '../widgets/guide_card.dart';

class ResumeScreen extends StatelessWidget {
  final Function(int) onNavigate;
  const ResumeScreen({super.key, required this.onNavigate});

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
        child: ListView(
          children: [
            Text(
              "Dernière prédiction",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 12),
            FutureBuilder(
              future: predictionRepository.getAllPredictions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text("Erreur: ${snapshot.error}");
                }

                final predictions = snapshot.data ?? [];
                if (predictions.isEmpty) {
                  return const Text("Aucune prédiction");
                } else {
                  return PredictionCard(prediction: predictions.last);
                }
              },
            ),
            const SizedBox(height: 24),
            Text(
              "Fonctionnalités de l'application",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 12),
            GuideCard(
              icon: Icons.medical_services,
              title: 'Prédiction',
              description: 'Prédisez votre glycémie.',
              onTap: () => onNavigate(1),
            ),
            const SizedBox(height: 8),
            GuideCard(
              icon: Icons.history,
              title: 'Historique',
              description: 'Consultez vos prédictions passées.',
              onTap: () => onNavigate(2),
            ),
            const SizedBox(height: 8),
            GuideCard(
              icon: Icons.settings,
              title: 'Paramètres',
              description: 'Gérez vos préférences.',
              onTap: () => onNavigate(3),
            ),
          ],
        ),
      ),
    );
  }
}
