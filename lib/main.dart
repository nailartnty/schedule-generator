import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(ScheduleGeneratorApp());
}

class ScheduleGeneratorApp extends StatelessWidget {
  const ScheduleGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Schedul eGenerator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true
      ),
      home: Placeholder(),
    );
  }
}