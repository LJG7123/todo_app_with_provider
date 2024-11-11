import 'package:todo_with_provider/model/todo_model.dart';
import 'package:todo_with_provider/repository/todo_list_repository.dart';

class TodoListService {
  TodoListRepository repository;

  TodoListService({required this.repository});

  Future<List<TodoModel>> getTodoList() => repository.getTodoList();

  Future<void> addTodo(String title) => repository.addTodo(title);

  Future<void> removeTodo(int index) => repository.removeTodo(index);
}
