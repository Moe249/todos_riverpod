import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todos_riverpod/models/todo.dart';

import '../../../main.dart';

class Toolbar extends HookWidget {
  const Toolbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final filter = useProvider(todoListFilter);
    final search = useProvider(todoListSearch);

    final searchWidget = TextField(
      expands: false,
      controller: searchController,
      decoration: const InputDecoration(
        hintText: 'Search',
        border: InputBorder.none,
        icon: Icon(Icons.search),
      ),
      onChanged: (value) {
        search.state = value;
      },
    );
    Color textColorFor(TodoListFilter value) {
      return filter.state == value ? Colors.blue : null;
    }

    return Material(
      child: Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            '${useProvider(uncompletedTodosCount).toString()} items left',
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(width: 10),
          MediaQuery.of(context).size.width > 600
              ? ConstrainedBox(
                  constraints: const BoxConstraints(
                    // minWidth: 80,
                    maxWidth: 120,
                  ),
                  child: searchWidget,
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: searchWidget),
          SizedBox(width: 10),
          Tooltip(
            key: allFilterKey,
            message: 'All todos',
            child: FlatButton(
              onPressed: () => filter.state = TodoListFilter.all,
              visualDensity: VisualDensity.compact,
              textColor: textColorFor(TodoListFilter.all),
              child: const Text('All'),
            ),
          ),
          Tooltip(
            key: activeFilterKey,
            message: 'Only uncompleted todos',
            child: FlatButton(
              onPressed: () => filter.state = TodoListFilter.active,
              visualDensity: VisualDensity.compact,
              textColor: textColorFor(TodoListFilter.active),
              child: const Text('Active'),
            ),
          ),
          Tooltip(
            key: completedFilterKey,
            message: 'Only completed todos',
            child: FlatButton(
              onPressed: () => filter.state = TodoListFilter.completed,
              visualDensity: VisualDensity.compact,
              textColor: textColorFor(TodoListFilter.completed),
              child: const Text('Completed'),
            ),
          ),
        ],
      ),
    );
  }
}
