import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ural_task/features/tasks/provider/task_provider.dart';

class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasks;

    final total = tasks.length;
    final pending = tasks.where((t) => t.status == 'Pending').length;
    final inProgress = tasks.where((t) => t.status == 'In Progress').length;
    final completed = tasks.where((t) => t.status == 'Completed').length;
    final highPriority = tasks.where((t) => t.priority == 'High').length;

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildCard(context, 'Total Tasks', total, Colors.indigo, Icons.list_alt),
        _buildCard(context, 'Pending', pending, Colors.orange, Icons.hourglass_empty),
        _buildCard(context, 'In Progress', inProgress, Colors.blue, Icons.autorenew),
        _buildCard(context, 'Completed', completed, Colors.green, Icons.check_circle),
        _buildCard(context, 'High Priority', highPriority, Colors.red, Icons.priority_high),
      ],
    );
  }

  Widget _buildCard(BuildContext context, String title, int value, Color color, IconData icon) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Icon(icon, size: 18, color: color),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value.toString(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}