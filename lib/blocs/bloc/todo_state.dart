// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'todo_bloc.dart';

@immutable
abstract class TodoState {}

abstract class TodoActionState extends TodoState {}

class TodoInitial extends TodoState {}

class TodoLoadingState extends TodoState {}

class TodoLoadSuccessState extends TodoState {
  final List todo;
  TodoLoadSuccessState({
    required this.todo,
  });
}
class TodoErrorState extends TodoState {}

class NavigativeTodotoCreate extends TodoActionState {}

class NavigativeTodotoEdit extends TodoActionState {
  final todolist todo;
  final int index;
  NavigativeTodotoEdit(this.todo, this.index);
}

class NavigativeEdittoTodo extends TodoActionState {}

class TodoClickCreate extends TodoActionState {}

class TodoClickEdit extends TodoActionState {}

class TodoClickDelete extends TodoActionState {}

class TodoClickCheckBox extends TodoActionState {}
