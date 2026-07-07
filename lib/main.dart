import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ural_task/core/them/theme_provider.dart';
import 'package:ural_task/features/tasks/pages/home_screen.dart';
import 'package:ural_task/features/tasks/provider/task_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Task Manager',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.indigo,
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.grey.shade50,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.indigo,
              brightness: Brightness.dark,
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}