import 'package:todo_with_provider/data/todo_list_data_source.dart';
import 'package:todo_with_provider/model/todo_model.dart';

class TodoListRepository {
  final TodoListDataSource _dataSource = TodoListDataSource();

  Future<List<TodoModel>> getTodoList() async {
    return _dataSource.loadTodoList();
  }

  Future<void> addTodo(String title) async {
    _dataSource.insertTodo({'title': title});
  }

  Future<void> removeTodo(int index) async {
    _dataSource.deleteTodo(index);
  }
}
