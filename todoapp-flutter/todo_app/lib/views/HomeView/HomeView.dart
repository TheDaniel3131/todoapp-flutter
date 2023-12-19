import 'package:flutter/material.dart';
import 'package:todo_app/controllers/AlertDialogController.dart';
import 'package:todo_app/controllers/ToDoController.dart';
import 'package:todo_app/models/enums/CRUD.dart';
import 'package:todo_app/views/ManageToDoView/ManageToDoView.dart';
import 'package:todo_app/views/ToDoListView/ToDoListView.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>{
  // custom controller
  final TodoController todoController = TodoController();
  final AlertDialogController alertDialogController = AlertDialogController();

  // flutter build in controller
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final PageController pageController = PageController();
  int currentPageIndex = 0;

  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index){
          setState((){
            FocusScope.of(context).unfocus();
            currentPageIndex = index;
          });
        },
        children: [
          // Page 1 - Todo List
          ToDoListView(
            todoController: todoController,
            alertDialogController: alertDialogController,
            titleController: titleController,
            descriptionController: descriptionController,
            pageController: pageController,
          ), // ToDoListView

          // Page 2 - Add Todo
          ManageToDoView(
            titleController: titleController,
            descriptionController: descriptionController,
            todoController: todoController,
            alertDialogController: alertDialogController,
            pageController: pageController,
            crud: CRUD.C,
          )
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (index){
          setState((){
            currentPageIndex = index;
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Todo List",
          ), 
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add Todo",
          ), 
        ],
      ),
    );
  }
}