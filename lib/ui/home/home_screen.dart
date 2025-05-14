import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schedule_generator/models/task.dart';
import 'package:schedule_generator/services/gemini_service.dart';
import 'package:schedule_generator/ui/home/components/appbar.dart';
import 'package:schedule_generator/ui/home/components/task_list.dart';
import 'package:schedule_generator/ui/home/components/task_input_section.dart';
import 'package:schedule_generator/ui/home/result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [];
  final GeminiService geminiService = GeminiService();
  bool isLoading = false;
  String? generatedResult;

  void addTask(Task task) {
    setState(() => tasks.add(task));
  }

  void removeTask(int index) {
    setState(() => tasks.removeAt(index));
  }

  Future<void> generateSchedule() async {
    setState(() => isLoading = true);
    try {
      final result = await geminiService.generateSchedule(tasks);
      generatedResult = result;
      if (context.mounted) _showSuccessDialog();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to generate schedule: $e")),
        );
      }
    }
    setState(() => isLoading = false);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Congrats!"),
        content: Text("Schedule generated successfully"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ResultScreen(
                    result: generatedResult ?? "There's no result. Please try to generate another task",
                  ),
                ),
              );
            },
            child: Text("View Result"),
          ),
        ],
      ),
    );
  }

  void _openAddTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: TaskInputSection(onTaskAdded: addTask),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final purpleColor = Color(0xFF6949FF);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Appbar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text("Good Morning, Nelaa!", style: TextStyle(fontSize: 15, color: Colors.grey[600])),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                  children: [
                    TextSpan(text: "Yokk selesain "),
                    TextSpan(text: "tugas\n", style: TextStyle(color: purpleColor)),
                    TextSpan(text: "kamu sekarang!"),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search your task",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(Icons.search_rounded, color: Color(0xFFD5D3D3)),
                  ),
                  filled: true,
                  fillColor: Color(0xFFF9F9F9),
                  hintStyle: TextStyle(
                    color: Color(0xFFD5D3D3),
                    fontSize: 18
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Today's Task", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: isLoading ? null : generateSchedule,
                    child: isLoading
                        ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text("Generate Schedule", style: TextStyle(color: purpleColor, fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: tasks.isEmpty
                    ? Center(child: Text("No tasks yet"))
                    : TaskList(tasks: tasks, onRemove: removeTask),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTaskModal,
        label: Text("Add Task", style: TextStyle(fontSize: 16, color: Colors.white)),
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: purpleColor,
      ),
    );
  }
}
