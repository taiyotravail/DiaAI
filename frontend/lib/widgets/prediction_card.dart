import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/prediction.dart';

class PredictionCard extends StatelessWidget {
  final Prediction prediction;
  final VoidCallback? onDelete;

  const PredictionCard({
    super.key,
    required this.prediction,
    this.onDelete,
  });

  /// Déterminer la couleur basée sur la valeur glycémique
  Color _getGlycemieColor(double value) {
    if (value < 0.70 || value > 1.80) {
      return Colors.redAccent;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final glucoseColor = _getGlycemieColor(prediction.glycemiePredite);
    final formattedDate =
        DateFormat('dd/MM/yyyy HH:mm').format(prediction.dateCreation);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec date et bouton supprimer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red,
                    iconSize: 20,
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Résultat principal
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Glycémie prédite
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Glycémie prédite",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${prediction.glycemiePredite.toStringAsFixed(2)} g/L",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: glucoseColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Separator
                Container(
                  width: 1,
                  height: 60,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),

                // Données d'entrée
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildInputRow(
                        "Glycémie avant",
                        "${prediction.glycemieAvant.toStringAsFixed(2)} g/L",
                      ),
                      const SizedBox(height: 8),
                      _buildInputRow(
                        "Glucides",
                        "${prediction.glucides.toStringAsFixed(0)} g",
                      ),
                      const SizedBox(height: 8),
                      _buildInputRow(
                        "Insuline",
                        "${prediction.insuline.toStringAsFixed(1)} U",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
