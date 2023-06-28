part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

class TodoInitialEvent extends TodoEvent {}

class TodoActionEvent extends TodoEvent {}

class TodoLoading extends TodoEvent {}

class TodoLoadSuccess extends TodoEvent {}

class NavigativeTodotoCreateEvent extends TodoEvent {}

class NavigativeTodotoEditEvent extends TodoEvent {
  final todolist todo;
  final int index;
  NavigativeTodotoEditEvent(
    this.todo,
    this.index,
  );
}

class NavigativeEdittoTodoEvent extends TodoEvent {}

class TodoClickCreaeEvent extends TodoEvent {
  final todolist todo;
  final ToDoDataBase db;
  TodoClickCreaeEvent(
    this.todo,
    this.db,
  );
}

class TodoClickEditEvent extends TodoEvent {
  final todolist todo;
  final ToDoDataBase db;
  final int index;
  TodoClickEditEvent(
    this.todo,
    this.db,
    this.index,
  );
}

class TodoClickDeleteEvent extends TodoEvent {
  final int index;
  final ToDoDataBase db;
  TodoClickDeleteEvent(
    this.index,
    this.db,
  );
}

class TodoClickCheckBoxEvent extends TodoEvent {
  final int index;
  final ToDoDataBase db;
  TodoClickCheckBoxEvent(
    this.index,
    this.db,
  );
}
