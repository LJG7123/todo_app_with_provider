import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_with_provider/model/todo_model.dart';

class TodoListDataSource {
  static Database? _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initializeDatabase();
    return _db!;
  }

  Future<Database> initializeDatabase() async {
    String path =
        join((await getApplicationDocumentsDirectory()).path, 'todo_list.db');

    return await openDatabase(path, onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE todo_list(id INTEGER PRIMARY KEY, title TEXT)');
    }, version: 1);
  }

  Future<List<TodoModel>> loadTodoList() async {
    return (await (await db).query('todo_list'))
        .map((map) => TodoModel(
            id: int.parse(map['id'].toString()),
            title: map['title'].toString()))
        .toList();
  }

  Future<void> insertTodo(Map<String, dynamic> todo) async {
    await (await db).insert('todo_list', todo,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteTodo(int index) async {
    await (await db).delete('todo_list', where: 'id = ?', whereArgs: [index]);
  }
}
