import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../blocs/bloc_exports.dart';
import '../notifications/notification_service.dart';
import '../screens/drawer.dart';
import '../data/database.dart';
import '../widgets/search_box.dart';
import '../widgets/todo_tile.dart';
import '../screens/create_task.dart';
import 'edit_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotificationsServices notificationsServices = NotificationsServices();
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  // reference the hive box
  final _myBox = Hive.box<List>('mybox');
  ToDoDataBase db = ToDoDataBase();
  List _foundToDo = [];
  @override
  void initState() {
    // if this is the 1st time ever open in the app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }
    bloc.add(TodoInitialEvent());
    _foundToDo = db.toDoList;
    super.initState();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    notificationsServices.initialiseNotifications();
  }

  TodoBloc bloc = TodoBloc();

  // text controller
  // final _controller = TextEditingController();
  // checkbox was tapped
  void checkBoxChanged(int index) {
    // final text = db.toDoList[index].title;
    bloc.add(TodoClickCheckBoxEvent(index, db));
    setState(() {
      // db.toDoList[index].isDone = !db.toDoList[index].isDone;
    });
    // notificationsServices.showNotification(
    //   'Change properties',
    //   '$text attribute has been changed',
    // );
    // db.updateDataBase();
  }

  void createSchedule(int index) {
    final text = db.toDoList[index].title;
    final date1 =
        DateTime.parse(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()));
    final date2 = DateTime.parse(
        DateFormat('yyyy-MM-dd HH:mm').format(db.toDoList[index].dateEnd));
    final minute = date2.difference(date1);
    notificationsServices.showNotification(
      'Create Schedule',
      '$text has been schedule',
    );
    notificationsServices.scheduleNotification(
      'Schedule Notifications',
      '$text has arrived at the scheduled time',
      minute.inMinutes,
    );
  }

  // void scheduleExpirations(int index) {
  //   final text = db.toDoList[index].title;
  //   notificationsServices.showNotification(
  //     'Schedule Notifications',
  //     '$text is overdue to create schedule',
  //   );
  // }

  // delete task
  void deleteTask(int index) {
    // setState(() {
    //   db.toDoList.removeAt(index);
    // });
    // db.updateDataBase();
    final text = db.toDoList[index].title;
    notificationsServices.showNotification(
      'Remove a task',
      '$text has been removed',
    );
    bloc.add(TodoClickDeleteEvent(index, db));
    setState(() {});
  }

  void runFilter(String enteredkeyword) {
    List results = [];
    if (enteredkeyword.isEmpty) {
      results = db.toDoList;
    } else {
      results = db.toDoList
          .where((item) =>
              item.title.toLowerCase().contains(enteredkeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is NavigativeTodotoCreate) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateNewTask(
                  todoBloc: bloc,
                ),
              ),
            );
          } else if (state is NavigativeTodotoEdit) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditTask(
                  todo: state.todo,
                  index: state.index,
                  todoBloc: bloc,
                ),
              ),
            );
          } else if (state is TodoClickCreate) {
            Navigator.of(context).pop(state);
            setState(() {});
          }
        },
        bloc: bloc,
        listenWhen: (previous, current) => current is TodoActionState,
        buildWhen: (previous, current) => current is! TodoActionState,
        builder: (context, state) {
          switch (state.runtimeType) {
            case TodoLoadingState:
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            case TodoLoadSuccessState:
              final successState = state as TodoLoadSuccessState;
              return Scaffold(
                backgroundColor: Colors.yellow[200],
                appBar: AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TO DO APP'),
                      InkWell(
                        onTap: () {
                          notificationsServices.stopNotifications();
                          notificationsServices.showNotification(
                            'Cancel Schedule',
                            'All Schedules have been canceled',
                          );
                        },
                        child: const Icon(Icons.notifications_off),
                      ),
                    ],
                  ),
                  elevation: 0,
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    bloc.add(NavigativeTodotoCreateEvent());
                  },
                  child: const Icon(Icons.add),
                ),
                body: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Center(
                        child: Chip(
                          label: Text(
                            '${successState.todo.length} task',
                            // '',
                          ),
                        ),
                      ),
                    ),
                    SearchBox(
                      runFilter: (value) => runFilter(value),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _foundToDo.length,
                        itemBuilder: (context, index) {
                          return ToDoTile(
                            index: index,
                            todo: _foundToDo[index],
                            onChanged: (context) => checkBoxChanged(index),
                            deleteFunction: (context) => deleteTask(index),
                            scheduleFunction: () => createSchedule(index),
                            // scheduleExpiration: () => scheduleExpirations(index),
                            // editFunction: (context) => editTask(index),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                drawer: const Drawer_navbar(),
              );
            case TodoErrorState:
              return const Scaffold(
                body: Center(
                  child: Text('ERROR'),
                ),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}

// save new task
  // void saveNewTask() {
  //   final text = _controller.text.toString();
  //   // setState(() {
  //   //   db.toDoList.add(todolist(
  //   //     title: _controller.text,
  //   //     dateStart: start,
  //   //     dateEnd: end,
  //   //   ));
  //   //   _controller.clear();
  //   // });
  //   notificationsServices.showNotification(
  //     'Create a task',
  //     '$text has been created',
  //   );
  //   Navigator.of(context).pop();
  //   db.updateDataBase();
  // }

  // save edit task
  // void saveTask(int index) {
  //   final before = db.toDoList[index].title;
  //   final after = _controller.text.toString();
  //   setState(() {
  //     db.toDoList[index].title = _controller.text;
  //     _controller.clear();
  //   });
  //   notificationsServices.showNotification(
  //     'Edit a task',
  //     '$before change to $after',
  //   );
  //   Navigator.of(context).pop();
  //   db.updateDataBase();
  // }

  // create a new task
  // void createNewTask() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return DialogBox(
  //         controller: _controller,
  //         onSave: saveNewTask,
  //         onCancel: () => Navigator.of(context).pop(),
  //       );
  //     },
  //   );
  // }
  
  // edit task
  // void editTask(int index) {
  //   _controller.text = db.toDoList[index].title;
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return EditBox(
  //         controller: _controller,
  //         onEdit: () => saveTask(index),
  //         onCancel: () => Navigator.of(context).pop(),
  //       );
  //     },
  //   );
  // }
