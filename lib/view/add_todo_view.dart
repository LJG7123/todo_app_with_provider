import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_provider/repository/todo_list_repository.dart';
import 'package:todo_with_provider/service/todo_list_service.dart';
import 'package:todo_with_provider/viewmodel/todo_list_viewmodel.dart';

class AddTodoPage extends StatelessWidget {
  const AddTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TodoListViewModel(
            service: TodoListService(repository: TodoListRepository())),
        child: AddTodoView());
  }
}

class AddTodoView extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  AddTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Consumer<TodoListViewModel>(builder: (context, model, child) {
        return Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'todo title'),
                  )),
                  ElevatedButton(
                      onPressed: () {
                        model.addTodo(_controller.text);
                        Navigator.of(context).pop();
                      },
                      child: const Text('add'))
                ],
              ),
            ));
      }),
    );
  }
}
