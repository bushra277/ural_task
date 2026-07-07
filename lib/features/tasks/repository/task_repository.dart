import 'package:ural_task/core/database/database_helper.dart';
import 'package:ural_task/features/tasks/models/task_model.dart';

class TaskRepository {

  Future<int> insertTask(TaskModel task) async {
    try {
      final db = await DatabaseHelper.getDatabase();
      return await db.insert('tasks', task.toMap());
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  Future<List<TaskModel>> getAllTasks({String orderBy = 'created_at DESC'}) async {
    try {
      final db = await DatabaseHelper.getDatabase();
      final result = await db.query('tasks', orderBy: orderBy);
      return result.map((e) => TaskModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  Future<int> updateTask(TaskModel task) async {
    try {
      final db = await DatabaseHelper.getDatabase();
      return await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<int> deleteTask(int id) async {
    try {
      final db = await DatabaseHelper.getDatabase();
      return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  Future<List<TaskModel>> searchTasks(String query) async {
    try {
      final db = await DatabaseHelper.getDatabase();
      final result = await db.query(
        'tasks',
        where: 'title LIKE ? OR description LIKE ? ',
        whereArgs: ['%$query%', '%$query%'],
      );
      return result.map((e) => TaskModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Failed to search tasks: $e');
    }
  }

  Future<List<TaskModel>> filterTasks({
    String? status,
    String? priority,
  }) async {
    try {
      final db = await DatabaseHelper.getDatabase();

      List<String> whereConditions = [];
      List<dynamic> whereArgs = [];

      if (status != null && status != 'All') {
        whereConditions.add('status = ?');
        whereArgs.add(status);
      }

      if (priority != null && priority != 'All') {
        whereConditions.add('priority = ?');
        whereArgs.add(priority);
      }

      final result = await db.query(
        'tasks',
        where: whereConditions.isEmpty ? null : whereConditions.join(' AND '),
        whereArgs: whereArgs,
      );

      return result.map((e) => TaskModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Failed to filter tasks: $e');
    }
  }
}