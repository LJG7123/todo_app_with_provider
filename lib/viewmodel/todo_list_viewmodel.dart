import 'package:flutter/cupertino.dart';
import 'package:todo_with_provider/model/todo_model.dart';
import 'package:todo_with_provider/service/todo_list_service.dart';

class TodoListViewModel extends ChangeNotifier {
  late TodoListService service;
  List<TodoModel> _todoList = List.empty(growable: true);
  List<TodoModel> get todoList => _todoList;

  TodoListViewModel({required this.service}) {
    _getTodoList();
  }

  Future<void> _getTodoList() async {
    _todoList = await service.getTodoList();
    notifyListeners();
  }

  Future<void> addTodo(String todo) async {
    service.addTodo(todo).whenComplete(() {
      _getTodoList();
    });
  }

  Future<void> removeTodo(int index) async {
    service.removeTodo(index).whenComplete(() {
      _getTodoList();
    });
  }
}
