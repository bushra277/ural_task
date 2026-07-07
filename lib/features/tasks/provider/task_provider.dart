import 'package:flutter/material.dart';
import 'package:ural_task/features/tasks/models/task_model.dart';
import 'package:ural_task/features/tasks/repository/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository repository = TaskRepository();
  List<TaskModel> tasks=[];

  Future<void> getTasks({String orderBy = 'created_at DESC'})async{
    tasks = await repository.getAllTasks(orderBy: orderBy);
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async{
    await repository.insertTask(task);
    await getTasks();
  }

  Future<void> updateTask(TaskModel task) async{
    await repository.updateTask(task);
    await getTasks();
  }

  Future<void> deleteTask(int id) async{
    await repository.deleteTask(id);
    await getTasks();
  }

  Future<void> searchTasks(String query) async{
    tasks = await repository.searchTasks(query);
    notifyListeners();
  }

  Future<void> filterTasks({String? status , String? priority}) async{
    tasks = await repository.filterTasks(status: status , priority: priority);
    notifyListeners();
  }

}