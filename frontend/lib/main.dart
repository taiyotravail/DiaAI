import 'package:flutter/material.dart';
import 'screens/prediction_screen.dart';

void main() {
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
      home: const PredictionScreen(),
    );
  }
}
