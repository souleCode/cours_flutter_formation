import 'package:app/pages/admin.dart';
import 'package:app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/task_model.dart';
import 'models/theme_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskModel()),
        ChangeNotifierProvider(create: (_) => ThemeModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeModel>().isDark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: const HomeScreen(),
      routes: {'/admin': (context) => const AdminPage()},
    );
  }
}
