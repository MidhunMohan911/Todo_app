import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/todo.dart';

class AddTodo extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  Box todobox = Hive.box<Todo>('todo');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  labelText: 'title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text != '') {
                      Todo newTodo =
                          Todo(title: titleController.text, isCompleted: false);
                      todobox.add(newTodo);
                      Navigator.pop(context);
                    }
                  },
                  child:const Text(
                    'Add Todo',
                    style: TextStyle(fontSize: 20),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
