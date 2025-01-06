import 'dart:math';

import 'package:doneliost/core/enums/task_filter.dart';
import 'package:doneliost/core/enums/task_sorting.dart';
import 'package:doneliost/core/services/db_services.dart';
import 'package:doneliost/ui/widgets/custom_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/task_model.dart';



class TaskProvider extends ChangeNotifier {
  final DBServices _dbHelper = DBServices();
  List<TaskModel> _tasks = [];
  TaskFilter currentFilter = TaskFilter.all;
  TaskSortOption currentOption = TaskSortOption.none;

  List<TaskModel> get tasks => _tasks;

  TaskProvider() {
    fetchTasks();
  }

  Future<void> addTask(String title, String description, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Adding Task...'),
          ],
        ),
      ),
    );

    try {
      TaskModel task = TaskModel(
        title: title,
        description: description,
        done: 0,
      );

      await _dbHelper.insert(task);

      Navigator.of(context).pop();

      Get.back();
      CustomSnackBar.showSuccess('Task Added Successfully');
      fetchTasks();
    } catch (e) {
      Navigator.of(context).pop();
      CustomSnackBar.showError('Error adding task: $e');
      rethrow;
    }
  }

  int generateRandomNotificationId() {
    final random = Random();
    return random.nextInt(900) + 100;
  }

  Future<void> deleteTask(int taskId) async {
    try {
      await _dbHelper.deleteNoteById(taskId);
      CustomSnackBar.showSuccess('Task Deleted Successfully');
      fetchTasks();
    } catch (e) {
      CustomSnackBar.showError('Error deleting task: $e');
      rethrow;
    }
  }

  Future<void> updateTaskStatus(int taskId, int newStatus) async {
    try {
      TaskModel task = _tasks.firstWhere((task) => task.id == taskId);
      TaskModel updatedTask = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        done: 1,
      );

      await _dbHelper.updateNote(updatedTask);
      CustomSnackBar.showSuccess('Task Status Updated');
      fetchTasks();
    } catch (e) {
      CustomSnackBar.showError('Error updating task status: $e');
      rethrow;
    }
  }

  Future<void> fetchTasks() async {
    try {
      List<TaskModel> tasks = await _dbHelper.getAllNotes();

      switch (currentFilter) {
        case TaskFilter.done:
          tasks = tasks.where((task) => task.done == 1).toList();
          break;
        case TaskFilter.pending:
          tasks = tasks.where((task) => task.done == 0).toList();
          break;
        default:
      }

      if (currentOption == TaskSortOption.titleAscending) {
        tasks.sort((a, b) => a.title.compareTo(b.title)); // Ascending
      } else if (currentOption == TaskSortOption.titleDescending) {
        tasks.sort((a, b) => b.title.compareTo(a.title)); // Descending
      }

      _tasks = tasks;
      notifyListeners();
    } catch (e) {
      CustomSnackBar.showError('Error fetching tasks: $e');
      rethrow;
    }
  }

  // int? dateTimeToTimestamp(DateTime? dateTime) {
  //   return dateTime?.millisecondsSinceEpoch;
  // }
  //
  // DateTime? timestampToDateTime(int? timestamp) {
  //   return timestamp != null
  //       ? DateTime.fromMillisecondsSinceEpoch(timestamp)
  //       : null;
  // }
  //
  // Future<void> selectDate(BuildContext context) async {
  //   final initialDate = selectedDueDate ?? DateTime.now();
  //   final pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: initialDate,
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2100),
  //   );
  //   if (pickedDate != null) {
  //     selectedDueDate = pickedDate;
  //     notifyListeners();
  //   }
  // }

  void updateFilter(TaskFilter newFilter) {
    if (currentFilter != newFilter) {
      currentFilter = newFilter;
      fetchTasks();
    }
  }

  void updateSortOption(TaskSortOption sortOption) {
    if (currentOption != sortOption) {
      currentOption = sortOption;
      fetchTasks();
    }
  }
}
