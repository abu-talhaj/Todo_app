import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/db_helper.dart';
import 'package:todo_app/todo_details_screen.dart';
import 'package:todo_app/todo_model.dart';
import 'package:todo_app/todo_provider.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<bool> selectedIndex = [];

  TextEditingController titleClt = TextEditingController();
  TextEditingController contentClt = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = Provider.of<TodoProvider>(context, listen: false);
      await provider.loadTasks();
      setState(() {
        selectedIndex = List<bool>.filled(provider.taskList.length, false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final tasks = todoProvider.taskList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          "Todo List",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? Center(child: Text("Empty notes"))
          : ListView.builder(
              itemCount: tasks.length,

              itemBuilder: (context, index) {
                final to = tasks[index];
                bool isCheck = selectedIndex[index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodoDetailsScreen(
                            title: to.title,
                            content: to.content,
                          ),
                        ),
                      );
                    },
                    // leading: CircleAvatar(child: Text((index + 1).toString())),
                    leading: IconButton(
                      onPressed: () {
                        setState(() {
                          if (index > 0 &&
                              !selectedIndex[index - 1] &&
                              !isCheck) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("select your item")),
                            );
                            return;
                          }
                          selectedIndex[index] = !selectedIndex[index];
                        });
                      },
                      icon: Icon(
                        isCheck
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: isCheck ? Colors.green : Colors.grey,
                      ),
                    ),
                    title: Text(to.title),
                    subtitle: Text(to.content),
                    trailing: SizedBox(
                      height: 60.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.edit, color: Colors.green),
                          ),
                          IconButton(
                            onPressed: () async {
                              await todoProvider.deleteTask(to.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Task deleted successfully'),
                                ),
                              );
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          viewDialouge(context, todoProvider);
        },
      ),
    );
  }

  viewDialouge(context, index) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext dialogcontext) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              content: Column(
                children: [
                  TextField(
                    controller: titleClt,
                    decoration: InputDecoration(hintText: 'Title name'),
                  ),
                  TextField(
                    controller: contentClt,
                    decoration: InputDecoration(hintText: ' Description'),
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    TextButton(
                      child: Text('Save'),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        final title = titleClt.text.trim();
                        final content = contentClt.text.trim();
                        if (title.isNotEmpty && content.isNotEmpty) {
                          await todoProvider.addTask(
                            titleClt.text,
                            contentClt.text,
                          );
                          titleClt.clear();
                          contentClt.clear();
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Fill all fields")),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
