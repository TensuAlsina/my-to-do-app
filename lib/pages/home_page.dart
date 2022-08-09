// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mytodo/models/todo.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  TextEditingController _todoController = TextEditingController();
  bool isChecked = false;
  List<Todo> allTodos = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Add To-Do",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30, color: Colors.lightBlueAccent),
                        ),
                        TextField(
                          controller: _todoController,
                          autofocus: true,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 25),
                        ElevatedButton(
                            onPressed: () {
                              if (_todoController.text.isNotEmpty) {
                                Hive.box<Todo>('todo').add(
                                    Todo(_todoController.text.trim(), false));
                                _todoController.clear();
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Add'))
                      ],
                    ),
                  ));
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 70, left: 30, right: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.list,
                    size: 30,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                Text(
                  "To-Do",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.w700),
                ),
                ValueListenableBuilder(
                    valueListenable: Hive.box<Todo>('todo').listenable(),
                    builder: (context, box, _) => Text(
                          "${Hive.box<Todo>('todo').values.length} Task",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        )),
              ],
            ),
          ),
          Expanded(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: ValueListenableBuilder(
                    valueListenable: Hive.box<Todo>('todo').listenable(),
                    builder: (context, box, _) {
                      return ListView.separated(
                          separatorBuilder: ((context, index) => SizedBox(
                                height: 10,
                              )),
                          itemCount: Hive.box<Todo>('todo').length,
                          itemBuilder: (context, index) => Dismissible(
                                onDismissed: ((direction) {
                                  Hive.box<Todo>('todo').deleteAt(index);
                                }),
                                key: ValueKey(Hive.box<Todo>('todo')
                                    .values
                                    .toList()[index]
                                    .name),
                                child: Container(
                                  height: 80,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Text(
                                      Hive.box<Todo>('todo')
                                          .getAt(index)!
                                          .name
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ));
                    })),
          )
        ],
      ),
    );
  }
}
