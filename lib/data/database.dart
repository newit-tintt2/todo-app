import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/todo_tile.dart';

class ToDoDataBase extends HiveObject {
  
  List toDoList = [];

  final _myBox = Hive.box<List>('mybox');

  // run this method if this is the 1st time ever opening this app
  void createInitialData() {
    toDoList = [
      todolist(
        title: 'Make Tutorial',
        dateStart: DateTime(2023,5,05),
        dateEnd: DateTime(2023,5,20),
        isDone: true,
      ),
      todolist(
        title: 'Do Exercise',
        dateStart: DateTime(2023, 5, 15),
        dateEnd: DateTime(2023, 6, 2),
        isDone: false,
      ),
      todolist(
        title: 'todo3',
        dateStart: DateTime(2023, 5, 24),
        dateEnd: DateTime(2023, 5, 25),
        isDone: true,
      ),
    ];
    _myBox.put("TODOLIST", toDoList);
  }

  // load the data from database
  void loadData() {
    toDoList = _myBox.get("TODOLIST")!;
  }

  // update the database
  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}