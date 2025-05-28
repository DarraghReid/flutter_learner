import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/topic_provider.dart';
import 'screens/home_screen.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TopicProvider()..loadTopics(),
      child: const FlutterLearnerApp(),
    ),
  );
}

class FlutterLearnerApp extends StatelessWidget {
  const FlutterLearnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Learner',
      theme: ThemeData(
        primaryColor: const Color(0xFF02569B), // Flutter Blue
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF02569B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF02569B),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF02569B),
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
