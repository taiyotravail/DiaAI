import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://diaai.onrender.com';

  /// Clé API (bearer token) stockée en mémoire
  static String? _apiKey;

  /// Définit la clé API
  static void setApiKey(String key) {
    _apiKey = key;
  }

  /// Récupère la clé API
  static String? getApiKey() {
    return _apiKey;
  }

  /// Teste la connexion à l'API avec la clé fournie
  static Future<bool> testConnection(String apiKey) async {
    final url = Uri.parse('$baseUrl/');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setApiKey(apiKey); // Sauvegarde la clé si elle est valide
        return true;
      } else if (response.statusCode == 401) {
        return false; // Token invalide
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

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
        headers: {
          "Content-Type": "application/json",
          if (_apiKey != null) 'Authorization': 'Bearer $_apiKey',
        },
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
