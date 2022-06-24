import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/add_todo.dart';
import 'package:todo_app/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Box friendbox = Hive.box('friend');
  String? name;

  // addFriend() async {
  //   await friendbox.put('name', 'Cristiano Ronaldo');
  // }

  // getFriend() async {
  //   setState(() {
  //     name = friendbox.get('name');
  //   });
  // }

  // updateFriend() async {
  //   await friendbox.put('name', 'Lionel Messi');
  // }

  // deleteFriend() async {
  //   await friendbox.delete('name');
  // }

  Box todoBox = Hive.box<Todo>('todo');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive DB'),
        centerTitle: true,
      ),
      // body: Container(
      //   width: MediaQuery.of(context).size.width,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text('$name'),
      //       SizedBox(
      //         height: 30,
      //       ),
      //       ElevatedButton(onPressed: addFriend, child: Text('Create')),
      //       ElevatedButton(onPressed: getFriend, child: Text('Read')),
      //       ElevatedButton(onPressed: updateFriend, child: Text('Update')),
      //       ElevatedButton(onPressed: deleteFriend, child: Text('Delete')),
      //     ],
      //   ),
      // ),

      body: ValueListenableBuilder(
          valueListenable: todoBox.listenable(),
          builder: (context, Box box, _) {
            if (box.isEmpty) {
              return const Center(
                child: Text('No Todo available !'),
              );
            } else {
              return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    Todo todo = box.getAt(index);
                    return ListTile(
                      leading: Checkbox(
                          value: todo.isCompleted,
                          onChanged: (value) {
                            Todo newTodo =
                                Todo(title: todo.title, isCompleted: value!);
                            box.putAt(index, newTodo);
                          }),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                            fontSize: 20,
                            color: todo.isCompleted
                                ? Colors.green[500]
                                : Colors.black,
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                      trailing: Wrap(children: [
                        IconButton(
                            onPressed: () {
                              TextEditingController editName =
                                  TextEditingController(text: todo.title);
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.black,
                                      content: TextField(
                                        controller: editName,
                                        decoration: const InputDecoration(
                                            hintText: 'Enter a playlistName',
                                            fillColor: Colors.white70,
                                            filled: true),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              box.putAt(
                                                  index,
                                                  Todo(
                                                      title: editName.text,
                                                      isCompleted: false));
                                              // box.deleteAt(index);
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Yes',
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No')),
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.green,
                            )),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: const Text(
                                        'Do you want to delete',
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              box.deleteAt(index);
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Yes',
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No')),
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ]),
                    );
                  });
            }
          }),
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddTodo()));
          }),
    );
  }
}
