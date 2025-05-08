import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:schedule_generator/models/task.dart';

// file ini cara kita berkomunikasi dengan API kita

class GeminiService {
  // untuk gerbang komunikasi awal antara client(kode project/app yg udah di deploy) sama server(gemini api)
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

  /*
    logika untuk generating result dari input/prompt yang diberikan
    yang akan diotomasi oleh AI API 
  */
  Future<String> generateSchedule(List<Task> tasks) async {
    // kalau misal dia static ditandai _ didepannya
    _validateTasks(tasks); 
    // variable yg digunakan untuk menampung prompt request yang akan dieksekusi sama AI
    final prompt = _buildPrompt(tasks);

    // bolck try untuk percobaan pengiriman request ke AI 
    try {
      print("Prompt: \n$prompt");
      // var yg dipake untuk menampung dari request ke API AI
      final response = await http.post(
        // ini adalah starting point untuk penggunaan endpoint dari API harus menggunakan Uri.parse
        Uri.parse("$_baseUrl?key=$apiKey"),
        headers: {
          "Content-Type":"application/json"
        },
        // ini adalah body dari request yg akan di eksekusi ke API
        // endcode -> berantakan/ mentahan
        // decode -> udah bagus/rapi
        body: jsonEncode({
          // "contents" sesuatu yg akan kita kasih ke AI
          "contents": [{ 
            // role disini maksudnya -> seseorang yang melakukan intruksi kepada AI melalui prompt
            "role": "user",
            "parts": [
              {"text": prompt}
            ]
          }]
        })
      );

      return _handleResponse(response); // untuk memberi feedback kepada yg pemberi request
    } catch (e) {
      throw ArgumentError("Fail to generate schedule : $e");
    }
  }

  String _handleResponse(http.Response response) {
    // ini adalah fungsi untuk menangani response dari API
    final data = jsonDecode(response.body);

    /*
      switch adalah salah satu cabang dari perkondisian yang berisi
      statement general yang dapat dieksekusi oleh berbagai macam action(case) tanpa
      harus bergantung pada single-statement yg dimiliki oleh setiap action yg ada pada 
      parameter "case" -- sama kayak ifelse, dsb.

      response.statusCode -> status general

      1. Informational responses (100 – 199) -> Artinya server nerima permintaan kamu dan lagi proses, tapi belum selesai.
      2. Successful responses (200 – 299) -> berhasil mendapatkan response
      3. Redirection messages (300 – 399) -> Ini artinya kamu diminta pindah ke alamat lain. 
      Misalnya link udah pindah, jadi server bilang “eh, coba ke sini deh.”
      4. Client error responses (400 – 499) -> ni kesalahan dari sisi kamu (si pengguna). 
      Misalnya salah nulis alamat (404 Not Found) atau nggak punya izin akses (403 Forbidden).
      5. Server error responses (500 – 599) -> Ini kesalahan dari sisi server. 
      Kamu udah bener minta, tapi server-nya yang bermasalah (misalnya 500 Internal Server Error).
    */
    // wajib ada kalau kita mau pake AI
    switch (response.statusCode) { 
      case 200:
        return data["candidates"][0]["content"]["parts"][0]["text"];
      case 404:
        throw ArgumentError("Server Not Found");
      case 500:
        throw ArgumentError("Internal Server Error");
      default: // belum ketahuan errornya apa
        throw ArgumentError("Unknown Error : ${response.statusCode}");
    }
  }

  String _buildPrompt(List<Task> tasks) {
    // berfungsi untuk menyetting format tanggal dan waktu lokal(indonesia) 
    initializeDateFormatting();
    final dateFormatter = DateFormat("dd mm yy 'pukul' hh:mm, 'id_ID'");
    final taskList = tasks.map((task) {
      final formatDeadline = dateFormatter.format(task.deadline);
      // ${task.} -> kanpa dia ngarahnya ke import convert?
      return "Tugas: ${task.name} (Duration: ${task.duration} minutes, Deadline: $formatDeadline)";
    });

    return "'"
    // TODO: masukkan Prompt disini
    $taskList;
  }
  void _validateTasks(List<Task> tasks) {
    // ini merupakan bentuk dari single statement dari if-else condition
    if (tasks.isEmpty) throw ArgumentError("please input ur task here!?");
      
  }
}