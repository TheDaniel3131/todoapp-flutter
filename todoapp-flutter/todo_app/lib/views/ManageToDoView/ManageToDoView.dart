import 'package:flutter/material.dart';
import 'package:todo_app/controllers/AlertDialogController.dart';
import 'package:todo_app/controllers/ToDoController.dart';
import 'package:todo_app/models/Todo.dart';
import 'package:todo_app/models/enums/CRUD.dart';
import 'package:todo_app/views/components/textfields/CustomShadowTextField.dart';

class ManageToDoView extends StatelessWidget {
  const ManageToDoView({
    super.key, // Added 'Key?' type for super.key
    required this.titleController,
    required this.descriptionController,
    required this.todoController,
    required this.alertDialogController,
    required this.pageController,
    required this.crud,
    this.todo,
  });

  final TodoController todoController;
  final AlertDialogController alertDialogController;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final PageController pageController;
  final CRUD crud;
  final Todo? todo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Title
              Container(
                alignment: Alignment.center,
                child: Text(
                  crud == CRUD.C ? "Add Todo" : "Update Todo",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Title Text Field
              CustomShadowTextField(
                textController: titleController,
                title: "Title",
                hintText: "Enter Title Here",
                maxLines: 1,
              ),

              // Description Text Field
              CustomShadowTextField(
                textController: descriptionController,
                title: "Description",
                hintText: "Enter Description Here",
                maxLines: 5,
              ),

              // Add Todo Button
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text == ""){
                      alertDialogController.displayAlertDialog(
                        context,
                        crud,
                        "Title cannot be empty",
                      );
                      return;
                    }

                    if (descriptionController.text == ""){
                      alertDialogController.displayAlertDialog(
                        context,
                        crud,
                        "Description cannot be empty",
                      );
                      return;
                    }

                    switch(crud){
                      case CRUD.C:
                        DateTime now = DateTime.now();
                        int millisecondsSinceEpoch = now.millisecondsSinceEpoch;
                        String epochTime = millisecondsSinceEpoch.toString();
                        var newTodo = Todo(
                          id: "",
                          title: titleController.text,
                          description: descriptionController.text,
                          isCompleted: false,
                          isDateDisplayed: false,
                          timestamp: epochTime,
                        );
                        todoController.addTodo(newTodo);

                        // Hide the keyboard
                        FocusScope.of(context).unfocus();

                        pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                        break;

                      case CRUD.U:
                        todo?.title = titleController.text;
                        todo?.description = descriptionController.text;
                        todoController.updateTodo(todo!);
                        Navigator.pop(context); // Fixed 'Navigation' to 'Navigator'
                        break;

                      default:
                        break;
                    }

                    titleController.text = "";
                    descriptionController.text = "";

                  },

                  child: Text(crud == CRUD.C ? "Add Todo" : "Update Todo"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}