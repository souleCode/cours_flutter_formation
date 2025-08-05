import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../models/theme_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskModel>();
    final themeProvider = context.watch<ThemeModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Task Manager'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => context.read<ThemeModel>().toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration:
                          task.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: Checkbox(
                    value: task.isDone,
                    onChanged:
                        (_) =>
                            context.read<TaskModel>().toggleTaskStatus(index),
                  ),
                );
              },
            ),
          ),
          Padding(padding: const EdgeInsets.all(12.0), child: AddTaskForm()),
        ],
      ),
    );
  }
}

class AddTaskForm extends StatefulWidget {
  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final TextEditingController _controller = TextEditingController();

  void _submitTask() {
    final title = _controller.text.trim();
    if (title.isNotEmpty) {
      context.read<TaskModel>().addTask(title);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Nouvelle tâche...',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submitTask(),
          ),
        ),
        const SizedBox(width: 0),
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: _submitTask,
            icon: Icon(Icons.add_circle, size: 35),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/admin',
              ); // Adjust the route as needed
            },
            icon: Icon(Icons.arrow_forward, size: 35),
          ),
        ),
      ],
    );
  }
}
