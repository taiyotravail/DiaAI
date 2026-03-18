import 'package:flutter/material.dart';
import 'package:frontend/services/firestore_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'services/local_data_source.dart';
import 'services/prediction_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Repository global - sera initialisé au démarrage
late LocalPredictionRepository predictionRepository;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final localDataSource = LocalDataSource(prefs);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      rethrow;
    }
    Firebase.app();
  }

  final FirestoreDataSource cloudDataSource = FirestoreDataSource();
  predictionRepository = LocalPredictionRepository(localDataSource, cloudDataSource);

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
