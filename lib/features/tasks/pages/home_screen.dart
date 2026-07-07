import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ural_task/core/them/theme_provider.dart';
import 'package:ural_task/features/tasks/models/task_model.dart';
import 'package:ural_task/features/tasks/provider/task_provider.dart';
import 'package:ural_task/features/tasks/widget/export_button.dart';
import 'package:ural_task/features/tasks/widget/filter_search_bar.dart';
import 'package:ural_task/features/tasks/widget/task_form.dart';
import 'package:ural_task/features/tasks/widget/task_list.dart';
import 'package:ural_task/features/tasks/widget/task_summary.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TaskModel? _selectedTask;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TaskProvider>().getTasks());
  }

  void _editTask(TaskModel task) => setState(() => _selectedTask = task);
  void _closeForm() => setState(() => _selectedTask = null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Task Manager', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold , color: Color(0xFF0078D4))),
                  const ExportButton(),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return IconButton(
                        icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                        onPressed: themeProvider.toggleTheme,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isWide = constraints.maxWidth > 900;
                    final leftColumn = Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SummaryCards(),
                        const SizedBox(height: 16),
                        const FilterSearchBar(),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TaskList(onEdit: _editTask),
                          ),
                        ),
                      ],
                    );

                    final rightForm = Container(
                      width: isWide ? 340 : double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TaskForm(
                        key: ValueKey(_selectedTask?.id),
                        taskToEdit: _selectedTask,
                        onDone: _closeForm,
                      ),
                    );

                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: leftColumn),
                          const SizedBox(width: 16),
                          rightForm,
                        ],
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          rightForm,
                          const SizedBox(height: 16),
                          const SummaryCards(),
                          const SizedBox(height: 16),
                          const FilterSearchBar(),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 400,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: TaskList(onEdit: _editTask),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}