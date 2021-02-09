import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:todos_riverpod/models/todo.dart';
import 'package:todos_riverpod/ui/pages/home/todo_item.dart';
import 'package:todos_riverpod/ui/pages/home/toolbar.dart';
import 'package:todos_riverpod/ui/widgets/title.dart';

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final todos = useProvider(filteredTodos);
    final newTodoController = useTextEditingController();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              children: [
                TodoTitle(),
                TextField(
                  controller: newTodoController,
                  decoration: const InputDecoration(
                    labelText: 'What needs to be done?',
                  ),
                  onSubmitted: (value) {
                    if (value != null) {
                      context.read(todoListProvider).add(value);
                      newTodoController.clear();
                    }
                  },
                ),
                const SizedBox(height: 42),
                Column(
                  children: [
                    Toolbar(),
                    SizedBox(
                      height: 10,
                    ),
                    if (todos.isEmpty) const Text("No Todos"),
                    if (todos.isNotEmpty) const Divider(height: 0),
                    for (var i = 0; i < todos.length; i++) ...[
                      if (i > 0) const Divider(height: 0),
                      Dismissible(
                        key: ValueKey(todos[i].id),
                        onDismissed: (_) {
                          context.read(todoListProvider).remove(todos[i]);
                        },
                        child: TodoItem(todos[i]),
                      ),
                    ]
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
