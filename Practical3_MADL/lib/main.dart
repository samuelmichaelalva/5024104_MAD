import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<TaskManager>(
      create: (context) => TaskManager(),
      builder: (context, child) => const TaskManagementApp(),
    ),
  );
}

// DATA MODEL
class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final Color color;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.color,
  });

  Task copyWith({bool? isCompleted}) {
    return Task(
      id: id,
      title: title,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color,
    );
  }
}

// PROVIDER
class TaskManager extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Design System Documentation',
      color: Colors.blueAccent,
    ),
    Task(
      id: '2',
      title: 'Implement Responsive UI',
      color: Colors.orangeAccent,
    ),
    Task(
      id: '3',
      title: 'Unit Testing Integration',
      color: Colors.teal,
    ),
  ];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
      notifyListeners();
    }
  }

  void addTask(String title) {
    if (title.isEmpty) return;
    _tasks.add(
      Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        color: Colors.indigo,
      ),
    );
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}

// MAIN WIDGET
class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const TaskDashboard(),
    );
  }
}

// UI: DASHBOARD
class TaskDashboard extends StatefulWidget {
  const TaskDashboard({super.key});

  @override
  State<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends State<TaskDashboard> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Tracker"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Add new task...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: () {
                    taskProvider.addTask(_controller.text);
                    _controller.clear();
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return TaskCard(task: task);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// UI: CARD COMPONENT
class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: task.color,
          child: const Icon(
            Icons.task_alt,
            color: Colors.white,
            size: 16,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (_) {
                Provider.of<TaskManager>(
                  context,
                  listen: false,
                ).toggleTask(task.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                Provider.of<TaskManager>(
                  context,
                  listen: false,
                ).removeTask(task.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
