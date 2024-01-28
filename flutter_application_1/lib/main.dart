import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<String> todos = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  Future<void> _loadTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todos = prefs.getStringList('todos') ?? [];
    });
  }

  Future<void> _saveTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todos', todos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  todos.removeAt(index);
                  _saveTodoList();
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo = await showDialog<String>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('New Todo'),
                content: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(labelText: 'Event'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(_textController.text);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );

          if (newTodo != null) {
            setState(() {
              todos.add(newTodo);
              _textController.clear();
              _saveTodoList();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
