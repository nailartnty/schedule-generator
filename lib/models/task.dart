/*
  file yang berada didlm folder model..
  bisanya disebut dengan Data Class

  biasanya Data Class dipresentasikan dengan bundling..
  dengan menginmport library Parcelize = Android Native (membungkus semua dataClass agar bisa dipanggil dimanapun)
*/

class Task {
  final String name;
  final int duration;
  final DateTime deadline;
  Task({required this.name, required this.duration, required this.deadline});

  /* 
    untuk membuat suatu turunan dari object/ 
    salah satu contoh-> adanya function didalam function.
  */
  @override 
  String toString() {
    return "Task{name: $name, duration: $duration, deadline: $deadline}";
  }
}