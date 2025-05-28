import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/topic_provider.dart';

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
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Learner')),
        body: const Center(child: Text('Let’s get building!')),
      ),
    );
  }
}
