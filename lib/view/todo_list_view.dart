import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_provider/repository/todo_list_repository.dart';
import 'package:todo_with_provider/service/todo_list_service.dart';
import 'package:todo_with_provider/view/add_todo_view.dart';
import 'package:todo_with_provider/viewmodel/todo_list_viewmodel.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TodoListViewModel(
            service: TodoListService(repository: TodoListRepository())),
        child: const TodoListView());
  }
}

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TodoListViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Consumer<TodoListViewModel>(
        builder: (context, model, child) {
          return ListView.builder(
            itemCount: model.todoList.length,
            itemBuilder: (context, index) {
              return ListTileOpacity(
                  title: model.todoList[index].title,
                  buttonPressedListener: () {
                    model.removeTodo(model.todoList[index].id);
                  });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                    value: viewModel,
                    child: AddTodoView(),
                  )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ListTileOpacity extends StatefulWidget {
  final String title;
  final Function buttonPressedListener;

  const ListTileOpacity(
      {super.key, required this.title, required this.buttonPressedListener});

  @override
  State<ListTileOpacity> createState() => _ListTileOpacityState();
}

class _ListTileOpacityState extends State<ListTileOpacity>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    _animation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
            opacity: _animation.value,
            child: ListTile(
              title: Text(widget.title),
              trailing: IconButton(
                  onPressed: () async {
                    _controller.forward();
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      widget.buttonPressedListener();
                    });
                  },
                  icon: const Icon(Icons.delete, color: Colors.red)),
            ));
      },
    );
  }
}
