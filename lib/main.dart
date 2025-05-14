import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schedule_generator/ui/home/home_screen.dart';

// untuk menjalankan program2 yang penting
Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('id_ID', null);
  runApp(ScheduleGeneratorApp());
}

class ScheduleGeneratorApp extends StatelessWidget {
  const ScheduleGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Schedul Generator App',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: GoogleFonts.manropeTextTheme(),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true
      ),
      home: HomeScreen(),
    );
  }
}