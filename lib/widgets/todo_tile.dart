// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/blocs/bloc/todo_bloc.dart';

import '../data/database.dart';
import '../notifications/notification_service.dart';
import '../screens/edit_task.dart';

part 'todo_tile.g.dart';

@HiveType(typeId: 0)
class todolist{
  @HiveField(0)
  String? index;
  @HiveField(1)
  String title;
  @HiveField(2)
  DateTime dateStart;
  @HiveField(3)
  DateTime dateEnd;
  @HiveField(4)
  bool isDone;

  todolist({
    required this.title,
    required this.dateStart,
    required this.dateEnd,
    this.isDone = false,
  });

  
}

class ToDoTile extends StatelessWidget {
  TodoBloc todoBloc = TodoBloc();
  ToDoDataBase db = ToDoDataBase();
  final int index;
  final todolist todo;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  Function() scheduleFunction;
  Function() scheduleExpiration;
  // Function(BuildContext)? editFunction;
  ToDoTile({
    super.key,
    required this.index,
    required this.todo,
    required this.onChanged,
    required this.deleteFunction,
    required this.scheduleFunction,
    required this.scheduleExpiration,
    // required this.editFunction,
  });

  @override
  Widget build(BuildContext context) {
    db.loadData();
    final timeNow =
        DateTime.parse(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()));
    final timeEnd =
        DateTime.parse(DateFormat('yyyy-MM-dd HH:mm').format(todo.dateEnd));
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTask(
                      todo: todo,
                      index: index,
                      todoBloc: todoBloc,
                    ),
                  ),
                );
              },
              icon: Icons.edit,
              backgroundColor: Colors.blueAccent.shade200,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          // padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // checkbox
                Checkbox(
                  value: todo.isDone,
                  onChanged: onChanged,
                  activeColor: Colors.black,
                ),
                // take name
                Column(
                  children: [
                    Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      '${DateFormat('yyyy-MM-dd HH:mm').format(todo.dateStart)}   -   ${DateFormat('yyyy-MM-dd HH:mm').format(todo.dateEnd)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 92, 90, 90),
                      ),
                    ),
                  ],
                ),
                (timeNow.compareTo(timeEnd) < 0)
                    ? InkWell(
                      onTap: scheduleFunction,
                      child: const Icon(
                        Icons.notifications,
                      ),
                    )
                    : InkWell(
                      onTap: scheduleExpiration,
                      child: const Icon(
                        Icons.notifications_off,
                      ),
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
