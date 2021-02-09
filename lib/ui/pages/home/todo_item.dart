import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todos_riverpod/models/todo.dart';
import 'package:todos_riverpod/utils/config.dart';

class TodoItem extends HookWidget {
  const TodoItem(this.todo, {Key key}) : super(key: key);
  final Todo todo;
  @override
  Widget build(BuildContext context) {
    // final todo = useProvider(_currentTodo);
    final itemFocusNode = useFocusNode();
    useListenable(itemFocusNode);
    final isFocused = itemFocusNode.hasFocus;

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Material(
      // color: Colors.white,
      elevation: 6,
      shadowColor: themeInstance.currentTheme() == ThemeMode.light
          ? Colors.grey[50].withOpacity(0.5)
          : null,
      child: Focus(
        focusNode: itemFocusNode,
        onFocusChange: (focused) {
          if (focused) {
            textEditingController.text = todo.description;
          } else {
            context
                .read(todoListProvider)
                .edit(id: todo.id, description: textEditingController.text);
          }
        },
        child: ListTile(
          onTap: () {
            itemFocusNode.requestFocus();
            textFieldFocusNode.requestFocus();
          },
          leading: Checkbox(
            checkColor: Theme.of(context).primaryColor,
            value: todo.completed,
            onChanged: (value) =>
                context.read(todoListProvider).toggle(todo.id),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete_sweep_outlined,
              color: Colors.red.shade400,
            ),
            onPressed: () => context.read(todoListProvider).remove(todo),
          ),
          title: isFocused
              ? TextField(
                  autofocus: true,
                  focusNode: textFieldFocusNode,
                  controller: textEditingController,
                )
              : Text(todo.description),
        ),
      ),
    );
  }
}
