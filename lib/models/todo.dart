import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

var _uuid = Uuid();

class Todo {
  Todo({
    this.description,
    this.completed = false,
    String id,
  }) : id = id ?? _uuid.v4();

  final String id;
  final String description;
  final bool completed;

  @override
  String toString() {
    return 'Todo(description: $description, completed: $completed)';
  }
}

class TodoList extends StateNotifier<List<Todo>> {
  TodoList([List<Todo> initialTodos]) : super(initialTodos ?? []);

  void add(String description) {
    state = [
      ...state,
      Todo(description: description),
    ];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: !todo.completed,
            description: todo.description,
          )
        else
          todo,
    ];
  }

  void edit({@required String id, @required String description}) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: todo.completed,
            description: description,
          )
        else
          todo,
    ];
  }

  void remove(Todo target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}

final todoListProvider = StateNotifierProvider<TodoList>(
  (_) {
    return TodoList(
      [
        Todo(id: 'todo-1', description: "Hi"),
        Todo(id: 'todo-2', description: "Hello"),
        Todo(id: 'todo-3', description: "Hey there"),
      ],
    );
  },
);

enum TodoListFilter {
  all,
  active,
  completed,
}

final todoListFilter = StateProvider((_) => TodoListFilter.all);

final todoListSearch = StateProvider((_) => '');

final uncompletedTodosCount = Provider<int>(
  (ref) {
    return ref
        .watch(todoListProvider.state)
        .where((todo) => !todo.completed)
        .length;
  },
);

final filteredTodos = Provider<List<Todo>>(
  (ref) {
    final filter = ref.watch(todoListFilter);
    final search = ref.watch(todoListSearch);
    final todos = ref.watch(todoListProvider.state);

    List<Todo> filteredTodos;
    switch (filter.state) {
      case TodoListFilter.all:
        filteredTodos = todos;
        break;
      case TodoListFilter.completed:
        filteredTodos = todos.where((todo) => todo.completed).toList();
        break;
      case TodoListFilter.active:
        filteredTodos = todos.where((todo) => !todo.completed).toList();
        break;
    }

    return search.state.isEmpty
        ? filteredTodos
        : filteredTodos
            .where((todo) => todo.description
                .toLowerCase()
                .contains(search.state.toLowerCase()))
            .toList();
  },
);
