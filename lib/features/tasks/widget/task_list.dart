import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ural_task/features/tasks/models/task_model.dart';
import 'package:ural_task/features/tasks/provider/task_provider.dart';

class TaskList extends StatelessWidget {
  final Function(TaskModel) onEdit;

  const TaskList({super.key, required this.onEdit});

  Color _priorityColor(String priority) {
    if (priority == 'High') return Colors.red;
    if (priority == 'Medium') return Colors.blue;
    return Colors.grey;
  }

  Color _statusColor(String status) {
    if (status == 'Completed') return Colors.green;
    if (status == 'In Progress') return Colors.blue;
    return Colors.orange; // Pending
  }

  String _formatDate(String isoString) {
  final date = DateTime.tryParse(isoString);
  if (date == null) return '-';
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

  void _confirmDelete(BuildContext context, TaskModel task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel' , style: TextStyle(color: Color(0xFF0078D4)),)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0078D4)),
            onPressed: () {
              context.read<TaskProvider>().deleteTask(task.id!);
              Navigator.pop(ctx);
            },
            child: const Text('Delete' , style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  void _markCompleted(BuildContext context, TaskModel task) {
    final updated = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority,
      status: 'Completed',
      dueDate: task.dueDate,
      createdAt: task.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
    context.read<TaskProvider>().updateTask(updated);
  }

  @override
Widget build(BuildContext context) {
  final tasks = context.watch<TaskProvider>().tasks;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  if (tasks.isEmpty) {
    return const Center(
      child: Text('No tasks found', style: TextStyle(color: Colors.grey)),
    );
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(isDark ? Colors.grey.shade800 : Colors.grey.shade100,),
            columnSpacing: 28,
            horizontalMargin: 16,
            columns: const [
              DataColumn(label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Priority', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Due Date', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Created', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: tasks.map((task) {
              return DataRow(cells: [
                DataCell(Text(task.title, style: const TextStyle(fontWeight: FontWeight.w500))),
                DataCell(Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _priorityColor(task.priority).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    task.priority,
                    style: TextStyle(color: _priorityColor(task.priority), fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                )),
                DataCell(Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: _statusColor(task.status), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(task.status),
                  ],
                )),
                DataCell(Text(_formatDate(task.dueDate ?? ''), style: TextStyle(color: Colors.grey.shade700))),
                DataCell(Text(_formatDate(task.createdAt), style: TextStyle(color: Colors.grey.shade700))),
                DataCell(Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (task.status != 'Completed')
                      IconButton(
                        icon: const Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
                        tooltip: 'Mark as Completed',
                        onPressed: () => _markCompleted(context, task),
                      ),
                    IconButton(
                      icon: Icon(Icons.edit, size: 20, color: Colors.grey.shade700),
                      onPressed: () => onEdit(task),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () => _confirmDelete(context, task),
                    ),
                  ],
                )),
              ]);
            }).toList(),
          ),
        ),
      );
    },
  );
}
}