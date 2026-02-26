import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/input_card.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final TextEditingController _glycemieController = TextEditingController();
  final TextEditingController _glucidesController = TextEditingController();
  final TextEditingController _insulineController = TextEditingController();

  String _resultat = "";
  String _message = "Entrez vos données pour prédire";
  bool _isLoading = false;
  Color _resultColor = Colors.grey;

  Future<void> predictData() async {
    // On ferme le clavier
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _message = "Analyse en cours...";
    });

    try {
      // Conversion des textes en nombres (double)
      // On remplace les virgules par des points car l'API attend des nombres au format anglais
      double glycemie =
          double.tryParse(_glycemieController.text.replaceAll(',', '.')) ?? 0.0;
      double glucides =
          double.tryParse(_glucidesController.text.replaceAll(',', '.')) ?? 0.0;
      double insuline =
          double.tryParse(_insulineController.text.replaceAll(',', '.')) ?? 0.0;

      // Appel du service API
      final data = await ApiService.predictGlycemie(
        glycemieAvant: glycemie,
        glucides: glucides,
        insuline: insuline,
      );

      double prediction = data['glycemie_estimee'];

      setState(() {
        _resultat = "${prediction.toStringAsFixed(2)} g/L";
        _isLoading = false;

        // Logique couleur (Vert = Bon, Rouge = Mauvais)
        if (prediction < 0.70 || prediction > 1.80) {
          _resultColor = Colors.redAccent;
          _message = "Attention : Glycémie hors cible";
        } else {
          _resultColor = Colors.green;
          _message = "Glycémie prévue stable";
        }
      });
    } catch (e) {
      setState(() {
        _message = "Erreur: ${e.toString().replaceAll('Exception: ', '')}";
        _isLoading = false;
        _resultColor = Colors.redAccent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Gris très clair style iOS
      appBar: AppBar(
        title: const Text("DiaAI Assistant"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- CARTE DE RÉSULTAT ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _resultColor.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Glycémie estimée à 2h",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          _resultat.isEmpty ? "--" : _resultat,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: _resultColor,
                          ),
                        ),
                  const SizedBox(height: 10),
                  Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _resultColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "Saisie du repas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Champs de saisie
            InputCard(
              label: "Glycémie actuelle",
              suffix: "g/L",
              icon: Icons.water_drop,
              controller: _glycemieController,
            ),
            const SizedBox(height: 15),
            InputCard(
              label: "Glucides du repas",
              suffix: "grammes",
              icon: Icons.restaurant,
              controller: _glucidesController,
            ),
            const SizedBox(height: 15),
            InputCard(
              label: "Insuline rapide",
              suffix: "Unités",
              icon: Icons.medical_services,
              controller: _insulineController,
            ),

            const SizedBox(height: 30),

            // Bouton de prédiction
            ElevatedButton(
              onPressed: predictData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              child: const Text(
                "CALCULER LA PRÉDICTION",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
