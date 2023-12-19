import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/Todo.dart';
import 'package:uuid/uuid.dart';

class TodoController {
  final CollectionReference todosCollection =
      FirebaseFirestore.instance.collection('todos');

  Future<void> addTodo(Todo todo) async {
    var uuid = const Uuid();
    String newUuid = uuid.v4();
    await todosCollection.doc(newUuid).set({
      'title': todo.title,
      'description': todo.description,
      'isCompleted': todo.isCompleted,
      'isDateDisplayed': todo.isDateDisplayed,
      'timestamp': todo.timestamp,
    });
  }

  Future<void> updateTodo(Todo todo) async {
    await todosCollection.doc(todo.id).update({
      'title': todo.title,
      'description': todo.description,
      'isCompleted': todo.isCompleted,
      'isDateDisplayed': todo.isDateDisplayed,
      'timestamp': todo.timestamp,
    });
  }

  Future<void> deleteTodo(String todoId) async {
    await todosCollection.doc(todoId).delete();
  }

  Stream<QuerySnapshot> getTodos() {
    return todosCollection.snapshots();
  }
}
