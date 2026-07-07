import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ural_task/features/tasks/models/task_model.dart';
import 'package:ural_task/features/tasks/provider/task_provider.dart';

class TaskForm extends StatefulWidget {
  final TaskModel? taskToEdit;
  final VoidCallback onDone;

  const TaskForm({super.key, this.taskToEdit, required this.onDone});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  String _priority = 'Low';
  String _status = 'Pending';
  DateTime? _dueDate;

  bool get _isEditing => widget.taskToEdit != null;

  @override
  void initState() {
    super.initState();
    final task = widget.taskToEdit;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _priority = task?.priority ?? 'Low';
    _status = task?.status ?? 'Pending';
    _dueDate = task?.dueDate != null ? DateTime.tryParse(task!.dueDate!) : null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now().toIso8601String();
    final provider = context.read<TaskProvider>();

    final task = TaskModel(
      id: widget.taskToEdit?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      status: _status,
      dueDate: _dueDate?.toIso8601String(),
      createdAt: widget.taskToEdit?.createdAt ?? now,
      updatedAt: now,
    );

    if (_isEditing) {
      provider.updateTask(task);
    } else {
      provider.addTask(task);
    }

    widget.onDone();
  }

  InputDecoration _fieldDecoration(BuildContext context, {String? hint, IconData? icon}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: theme.hintColor),
      prefixIcon: icon != null ? Icon(icon, size: 20, color: theme.hintColor) : null,
      filled: true,
      fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _label(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).hintColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing ? 'Edit Task' : 'New Task',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0078D4),
              ),
            ),
            const SizedBox(height: 20),

            _label(context, 'Title *'),
            TextFormField(
              controller: _titleController,
              decoration: _fieldDecoration(context, hint: 'Enter task title...', icon: Icons.title),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Title is required' : null,
            ),
            const SizedBox(height: 18),

            _label(context, 'Description'),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: _fieldDecoration(context, hint: 'Add details...', icon: Icons.notes),
            ),
            const SizedBox(height: 18),

            _label(context, 'Priority'),
            DropdownButtonFormField<String>(
              value: _priority,
              isExpanded: true,
              dropdownColor: theme.cardColor,
              decoration: _fieldDecoration(context, icon: Icons.flag_outlined),
              items: ['Low', 'Medium', 'High']
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (value) => setState(() => _priority = value!),
            ),
            const SizedBox(height: 18),

            _label(context, 'Status'),
            DropdownButtonFormField<String>(
              value: _status,
              isExpanded: true,
              dropdownColor: theme.cardColor,
              decoration: _fieldDecoration(context, icon: Icons.timelapse),
              items: ['Pending', 'In Progress', 'Completed']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (value) => setState(() => _status = value!),
            ),
            const SizedBox(height: 18),

            _label(context, 'Due Date'),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: _pickDueDate,
              child: InputDecorator(
                decoration: _fieldDecoration(context, icon: Icons.calendar_today),
                child: Text(
                  _dueDate == null
                      ? 'Select a date'
                      : '${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: _dueDate == null ? theme.hintColor : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onDone,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Color(0xFF0078D4)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Cancel', style: TextStyle(color: Color(0xFF0078D4))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0078D4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      _isEditing ? 'Update Task' : 'Save Task',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}