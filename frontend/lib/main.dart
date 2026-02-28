import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'services/local_data_source.dart';
import 'services/prediction_repository.dart';

// Repository global - sera initialisé au démarrage
late LocalPredictionRepository predictionRepository;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  // Initialiser la source de données locale et le repository
  final localDataSource = LocalDataSource(prefs);
  // Initialiser le Repository pour qu'il soit accessible dans toutes les pages
  predictionRepository = LocalPredictionRepository(localDataSource);

  runApp(const DiaAIApp());
}

class DiaAIApp extends StatelessWidget {
  const DiaAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DiaAI',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF007AFF)),
      ),
      home: const HomeScreen(),
    );
  }
}
