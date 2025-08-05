import 'package:app_bd_local/db/task_db.dart';
import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await TaskDatabase.instance.getAllTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await TaskDatabase.instance.insertTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await TaskDatabase.instance.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await TaskDatabase.instance.deleteTask(id);
    await loadTasks();
  }
}
