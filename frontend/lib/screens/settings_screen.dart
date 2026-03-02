import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _apiKeyController;
  bool _isConnected = false;
  bool _isLoading = false;
  bool _showPassword = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController(
      text: ApiService.getApiKey() ?? '',
    );
    _isConnected = ApiService.getApiKey() != null;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiKey = _apiKeyController.text.trim();
      if (apiKey.isEmpty) {
        setState(() {
          _errorMessage = 'Veuillez entrer une clé API';
          _isLoading = false;
        });
        return;
      }

      final success = await ApiService.testConnection(apiKey);

      setState(() {
        _isConnected = success;
        _isLoading = false;
        if (!success) {
          _errorMessage = 'Clé API invalide. Veuillez vérifier.';
        }
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connexion réussie !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('Paramètres'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Configuration de l\'API',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isConnected ? Colors.green[50] : Colors.orange[50],
                border: Border.all(
                  color: _isConnected ? Colors.green : Colors.orange,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _isConnected ? Icons.check_circle : Icons.warning,
                    color: _isConnected ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _isConnected
                          ? 'Connecté à l\'API'
                          : 'Non connecté à l\'API',
                      style: TextStyle(
                        color: _isConnected ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Clé API (Bearer Token)',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _apiKeyController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                hintText: 'Entrez votre clé API',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _testConnection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Tester la connexion',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
