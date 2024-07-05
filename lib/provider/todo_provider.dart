import 'package:flutter/material.dart';
import 'package:todo_flutter/model/todo.dart';

class TodoProvider with ChangeNotifier {
  final Map<DateTime, List<Todo>> _todos = {};

  Map<DateTime, List<Todo>> get todos => _todos;

  void addTodo(
      DateTime date, String title, String startLocation, String endLocation) {
    if (_todos[date] == null) {
      _todos[date] = [];
    }
    _todos[date]!.add(
      Todo(
        title: title,
        date: date,
        startLocation: startLocation.isEmpty ? "" : startLocation,
        endLocation: endLocation.isEmpty ? "" : endLocation,
      ),
    );
    notifyListeners();
  }

  void checkTodoDone(DateTime date, int index) {
    final todo = todos[date]?[index];
    if (todo != null) {
      todo.isDone = !todo.isDone;
      notifyListeners();
    }
  }

  void deleteCheckedTodos(DateTime date) {
    if (todos[date] != null) {
      todos[date] = todos[date]!.where((todo) => !todo.isDone).toList();
      notifyListeners();
    }
  }

  int getTodoCount(DateTime date) {
    return todos[date]?.length ?? 0;
  }
}
