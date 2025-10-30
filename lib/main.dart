import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/todo_screen.dart';

import 'todo_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TodoProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TodoScreen());
  }
}
