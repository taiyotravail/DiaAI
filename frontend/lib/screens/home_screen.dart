import 'package:flutter/material.dart';
import 'prediction_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'resume_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ResumeScreen(),       // Résumé
    const PredictionScreen(),   // Faire une prédiction
    const HistoryScreen(),      // Historique
    const SettingsScreen(),     // Paramètres
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.summarize),
            label: "Résumé",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: "Prédiction",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Historique",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Paramètres",
          ),
        ],
      ),
    );
  }
}

