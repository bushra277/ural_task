import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ural_task/core/utils/csv_exporter.dart';
import 'package:ural_task/features/tasks/provider/task_provider.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.download, size: 18),
      label: const Text('Export CSV'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0078D4),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        final tasks = context.read<TaskProvider>().tasks;
        CsvExporter.exportTasks(tasks);
      },
    );
  }
}