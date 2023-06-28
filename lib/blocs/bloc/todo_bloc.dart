import 'dart:async';

import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/data/database.dart';

import '../../widgets/todo_tile.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final _myBox = Hive.box<List>('myBox');
  ToDoDataBase db = ToDoDataBase();
  TodoBloc() : super(TodoInitial()) {
    on<NavigativeTodotoCreateEvent>(_navigativeTodotoCreateEvent);
    on<NavigativeTodotoEditEvent>(_navigativeTodotoEditEvent);
    on<NavigativeEdittoTodoEvent>(_navigativeEdittoTodoEvent);
    on<TodoInitialEvent>(_todoInitialEvent);
    on<TodoClickCreaeEvent>(_todoClickCreateEvent);
    on<TodoClickEditEvent>(_todoClickEditEvent);
    on<TodoClickDeleteEvent>(_todoClickDeleteEvent);
    on<TodoClickCheckBoxEvent>(_todoClickCheckBoxEvent);
  }

  FutureOr<void> _todoInitialEvent(
      TodoInitialEvent event, Emitter<TodoState> emit) async {
    if (_myBox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    emit(TodoLoadingState());
    await Future.delayed(const Duration(seconds: 1));
    emit(TodoLoadSuccessState(todo: db.toDoList));
  }

  FutureOr<void> _navigativeTodotoCreateEvent(
      NavigativeTodotoCreateEvent event, Emitter<TodoState> emit) {
    emit(NavigativeTodotoCreate());
  }

  FutureOr<void> _navigativeTodotoEditEvent(
      NavigativeTodotoEditEvent event, Emitter<TodoState> emit) {
    // print('object');
    emit(NavigativeTodotoEdit(event.todo, event.index));
  }

  FutureOr<void> _navigativeEdittoTodoEvent(
      NavigativeEdittoTodoEvent event, Emitter<TodoState> emit) {
    emit(NavigativeEdittoTodo());
  }

  FutureOr<void> _todoClickCreateEvent(
      TodoClickCreaeEvent event, Emitter<TodoState> emit) {
    event.db.toDoList.add(event.todo);
    event.db.updateDataBase();
    emit(TodoClickCreate());
  }

  FutureOr<void> _todoClickEditEvent(
      TodoClickEditEvent event, Emitter<TodoState> emit) {
    event.db.toDoList[event.index] = event.todo;
    event.db.updateDataBase();
    emit(TodoClickEdit());
  }

  FutureOr<void> _todoClickDeleteEvent(
      TodoClickDeleteEvent event, Emitter<TodoState> emit) {
    event.db.toDoList.removeAt(event.index);
    event.db.updateDataBase();
    emit(TodoClickDelete());
  }

  FutureOr<void> _todoClickCheckBoxEvent(
      TodoClickCheckBoxEvent event, Emitter<TodoState> emit) {
    // if (event.db.toDoList[event.index].isDone != true) {
    //   event.db.toDoList[event.index].isDone =
    //       !event.db.toDoList[event.index].isDone;
    //   event.db.toDoList[event.index].dateEnd = DateTime.now();
    // }
    event.db.toDoList[event.index].isDone =
      !event.db.toDoList[event.index].isDone;
    event.db.updateDataBase();
    emit(TodoClickCheckBox());
  }

}
