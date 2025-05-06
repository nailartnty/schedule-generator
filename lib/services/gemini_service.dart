import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  // untuk gerbang awal antara client(kode project) sama server(gemini api)
  static const String _baseUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  final String apiKey;

  /*
    ini adalah sebuah ternary operator untuk mematikan 
    apakah nilai dari API KEY tersedia atau kosong
  */
  GeminiService() : apiKey = dotenv.env["GEMINI_API_KEY"] ?? "" { // ini syntax yg pendek dari ternary operator biar clean code 
    if (apiKey.isEmpty) {
      throw ArgumentError("Please input Your API KEY"); // error message
    }
  }

  // logika untuk generating result dari input yang diberikan
  // yang akan diotomasi oleh AI API
  Future<String> generateSchedule(List<Task> tasks) async {
    _validateTasks(tasks); // kalau misal dia static ditandai _ didepannya
    final prompt = _buildPrompt(tasks);

    try {
      
    } catch (e) {
      
    }
  }
}