import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/controllers/AlertDialogController.dart';
import 'package:todo_app/controllers/ToDoController.dart';
import 'package:todo_app/models/Todo.dart';
import 'package:todo_app/models/enums/CRUD.dart';
import 'package:todo_app/views/ManageToDoView/ManageToDoView.dart';
import 'package:flutter/material.dart';

class ToDoListView extends StatelessWidget {
  const ToDoListView({
    super.key,
    required this.todoController,
    required this.alertDialogController,
    required this.titleController,
    required this.descriptionController,
    required this.pageController,
  });

  final TodoController todoController;
  final AlertDialogController alertDialogController;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    bool isSwitching = false;
    return StreamBuilder<QuerySnapshot>(
      stream: todoController.getTodos(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          var todos = snapshot.data!.docs.toList().map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return Todo(
              id: doc.id,
              title: data['title'],
              description: data['description'],
              isCompleted: data['isCompleted'],
              isDateDisplayed: data['isDateDisplayed'],
              timestamp: data['timestamp'],
            );
          }).toList();

          todos.sort((a, b) => (b.timestamp).compareTo(a.timestamp));

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              var todo = todos[index];
              var tileKey = Key(todo.id);

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        key: tileKey,
                        title: Text(todo.title),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              color: Colors.green,
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                titleController.text = todo.title;
                                descriptionController.text = todo.description;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      appBar: AppBar(
                                        title: const Text("Edit Todo"),
                                        leading: IconButton(
                                          icon: const Icon(Icons.arrow_back),
                                          onPressed: () {
                                            titleController.text = "";
                                            descriptionController.text = "";
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                      body: ManageToDoView(
                                        titleController: titleController,
                                        descriptionController: descriptionController,
                                        todoController: todoController,
                                        alertDialogController: alertDialogController,
                                        pageController: pageController,
                                        crud: CRUD.U,
                                        todo: todo,
                                      )
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              color: Colors.red,
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                todoController.deleteTodo(
                                  todo.id,
                                );
                              },
                            ),
                            Checkbox(
                              key: ValueKey(todo.id),
                              value: todo.isCompleted,
                              onChanged: (value) {
                                todo.isCompleted = value!;
                                todoController.updateTodo(
                                  todo,
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          if (!isSwitching) {
                            isSwitching = true;
                            todo.isDateDisplayed = !todo.isDateDisplayed;
                            todoController.updateTodo(
                              todo,
                            );

                            // Add a delay before allowing another switch
                            Future.delayed(const Duration(milliseconds: 500), () {
                              isSwitching = false;
                            });
                          }
                        },
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: todo.isDateDisplayed
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: 98,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          "Description",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
                                      child: Text(
                                        todo.description,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}