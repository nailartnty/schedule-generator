import 'package:flutter/material.dart';
import 'package:schedule_generator/models/task.dart';

class TaskInputSection extends StatefulWidget {
  final void Function(Task) onTaskAdded;
  const TaskInputSection({super.key, required this.onTaskAdded});

  @override
  State<TaskInputSection> createState() => _TaskInputSectionState();
}

class _TaskInputSectionState extends State<TaskInputSection> {
  final taskController = TextEditingController();
  final durationController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void _addTask() {
    if (taskController.text.isEmpty ||
        durationController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) return;

    final deadline = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    widget.onTaskAdded(Task(
      name: taskController.text,
      duration: int.tryParse(durationController.text) ?? 0,
      deadline: deadline,
    ));

    taskController.clear();
    durationController.clear();
    Navigator.pop(context); // tutup popup
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  void _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  @override
  Widget build(BuildContext context) {
    final purpleColor = Color(0xFF6949FF);
    final greyText = TextStyle(fontSize: 12, color: Colors.grey[600]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Add Task", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.black),
                    onPressed: _addTask,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Title
              Text("the title of ur task", style: greyText),
              TextField(
                controller: taskController,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                decoration: InputDecoration(border: InputBorder.none),
              ),
              const SizedBox(height: 16),
              // Duration
              Text("the duration", style: greyText),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                decoration: InputDecoration(border: InputBorder.none),
              ),
              const SizedBox(height: 16),
              // Deadline
              Text("the deadline", style: greyText),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickDate,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: purpleColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        selectedDate == null
                          ? "set date"
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        style: TextStyle(color: purpleColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickTime,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: purpleColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        selectedTime == null
                          ? "set time"
                          : selectedTime!.format(context),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
