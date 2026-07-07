import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_selector/file_selector.dart';
import 'package:ural_task/features/tasks/models/task_model.dart';

class CsvExporter {
  static Future<void> exportTasks(List<TaskModel> tasks) async {
    List<List<dynamic>> rows = [
      ['ID', 'Title', 'Description', 'Priority', 'Status', 'Due Date', 'Created At'],
    ];

    for (var task in tasks) {
      rows.add([
        task.id,
        task.title,
        task.description ?? '',
        task.priority,
        task.status,
        task.dueDate ?? '',
        task.createdAt,
      ]);
    }

    String csvData = csv.encode(rows);

    final FileSaveLocation? location = await getSaveLocation(
      suggestedName: 'tasks_export.csv',
    );

    if (location == null) return;

    final file = File(location.path);
    await file.writeAsString(csvData);
  }
}