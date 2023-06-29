import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/tzdata.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:todo_list/data/database.dart';
import '../blocs/bloc_exports.dart';
import '../widgets/todo_tile.dart';
import '../screens/home_page.dart';
import '../notifications/notification_service.dart';

class CreateNewTask extends StatefulWidget {
  TodoBloc todoBloc = TodoBloc();
  CreateNewTask({
    super.key,
    required this.todoBloc,
  });

  @override
  State<CreateNewTask> createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  ToDoDataBase db = ToDoDataBase();
  NotificationsServices notificationsServices = NotificationsServices();
  // DateTimeRange dateRange =
  //     DateTimeRange(start: DateTime.now(), end: DateTime.now());
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  TextEditingController titleController = TextEditingController();
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    notificationsServices.initialiseNotifications();
  }

  @override
  Widget build(BuildContext context) {
    db.loadData();
    TodoBloc todoBloc = widget.todoBloc;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.yellow[200],
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                        settings: const RouteSettings(
                          arguments: 'Hello',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                const Text(
                  'Create todo',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            margin: const EdgeInsets.only(
              top: 30,
            ),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                const Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                        ),
                        onPressed: () async {
                          bool flag = true;
                          final date = await pickDate(flag);
                          if (date != null) {
                            setState(() => start = date);
                          }
                        },
                        child: Column(
                          children: [
                            const Text(
                              'Date start',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              DateFormat('yyyy/MM/dd HH:mm').format(start),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                        ),
                        onPressed: () async {
                          bool flag = false;
                          final date = await pickDate(flag);
                          if (date != null) {
                            setState(() => end = date);
                          }
                        },
                        child: Column(
                          children: [
                            const Text(
                              'Date end',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              DateFormat('yyyy/MM/dd HH:mm').format(end),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          (titleController.text.toString().length > 0)
                              ? MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor)
                              : null,
                    ),
                    onPressed: (titleController.text.toString().length > 0)
                        ? () {
                            final text = titleController.text.toString();
                            todolist todo = todolist(
                              title: titleController.text.toString(),
                              dateStart: start,
                              dateEnd: end,
                            );
                            // Navigator.of(context).pop(todo);
                            todoBloc.add(TodoClickCreaeEvent(todo, db));
                            notificationsServices.showNotification(
                              'create a task',
                              '$text has been created',
                            );
                          }
                        : null,
                    child: const Text(
                      'Add task',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickDate(bool flag) async {
    final oldDate = flag ? start : end;
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: oldDate,
      firstDate: DateTime(200),
      lastDate: DateTime(2030),
    );
    if (newDate == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: oldDate.hour,
        minute: oldDate.minute,
      ),
    );
    if (time == null) return;
    final newDateTime = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      time.hour,
      time.minute,
    );
    return newDateTime;
  }
}
