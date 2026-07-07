import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ural_task/features/tasks/provider/task_provider.dart';

class FilterSearchBar extends StatefulWidget {
  const FilterSearchBar({super.key});

  @override
  State<FilterSearchBar> createState() => _FilterSearchBarState();
}

class _FilterSearchBarState extends State<FilterSearchBar> {
  String _status = 'All';
  String _priority = 'All';

  void _applyFilters() {
    context.read<TaskProvider>().filterTasks(status: _status, priority: _priority);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final innerFillColor = isDark ? Colors.grey.shade800 : Colors.grey.shade50;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // ---------- Search Box ----------
          SizedBox(
            width: 240,
            child: TextField(
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                hintStyle: TextStyle(color: theme.hintColor),
                prefixIcon: Icon(Icons.search, color: theme.hintColor),
                filled: true,
                fillColor: innerFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  _applyFilters();
                } else {
                  context.read<TaskProvider>().searchTasks(value);
                }
              },
            ),
          ),

          _buildDropdown(
            context: context,
            label: 'Status',
            value: _status,
            items: const ['All', 'Pending', 'In Progress', 'Completed'],
            fillColor: innerFillColor,
            borderColor: borderColor,
            onChanged: (value) {
              setState(() => _status = value!);
              _applyFilters();
            },
          ),
          _buildDropdown(
            context: context,
            label: 'Priority',
            value: _priority,
            items: const ['All', 'Low', 'Medium', 'High'],
            fillColor: innerFillColor,
            borderColor: borderColor,
            onChanged: (value) {
              setState(() => _priority = value!);
              _applyFilters();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required String label,
    required String value,
    required List<String> items,
    required Color fillColor,
    required Color borderColor,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: TextStyle(color: theme.hintColor, fontWeight: FontWeight.w500),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: theme.cardColor,
              items: items
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s, style: TextStyle(color: theme.colorScheme.onSurface)),
                      ))
                  .toList(),
              onChanged: onChanged,
              style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}