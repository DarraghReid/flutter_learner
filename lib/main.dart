import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/topic_provider.dart';
import 'screens/home_screen.dart';


void main() async {
  // Ensure that Flutter bindings are initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  // Load topics from the database and preload sample topics if needed.
  final topicProvider = TopicProvider();
  await topicProvider.loadTopics();
  await topicProvider.preloadTopicsIfNeeded();

  runApp(
    ChangeNotifierProvider.value(
      value: topicProvider,
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
