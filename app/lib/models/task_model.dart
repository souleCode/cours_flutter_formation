import 'package:flutter/material.dart';
import 'task.dart';

class TaskModel extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(String title) {
    _tasks.add(Task(title: title));
    notifyListeners();
  }

  void toggleTaskStatus(int index) {
    _tasks[index].toggleDone();
    notifyListeners();
  }
}
