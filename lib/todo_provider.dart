import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/db_helper.dart';
import 'package:todo_app/todo_model.dart';
import 'package:flutter/foundation.dart';

class TodoProvider extends ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();
  List<TodoModel> _taskList = [];
  List<TodoModel> get taskList => _taskList;

  Future<void> loadTasks() async {
    _taskList = await _dbHelper.getAllTasks();
    notifyListeners();
  }

  Future<void> addTask(String title, String content) async {
    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    final newTask = TodoModel(id: null, title: title, content: content, date: now);

    await _dbHelper.insertTask(newTask);
    await loadTasks();
  }

  Future<void> updateTask(
    TodoModel task,
    String newTitle,
    String newContent,
  ) async {
    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final updatedTask = TodoModel(
      id: task.id,
      title: newTitle,
      content: newContent,
      date: now,
    );
    await _dbHelper.updateTask(updatedTask);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    await loadTasks();
  }
}
