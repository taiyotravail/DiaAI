import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://diaai.onrender.com';

  /// Prédit la glycémie à 2h après le repas
  static Future<Map<String, dynamic>> predictGlycemie({
    required double glycemieAvant,
    required double glucides,
    required double insuline,
  }) async {
    final url = Uri.parse('$baseUrl/predict');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "glycemie_avant": glycemieAvant,
          "glucides": glucides,
          "insuline": insuline,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}
