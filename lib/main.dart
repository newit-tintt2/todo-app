import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/widgets/todo_tile.dart';
import 'screens/home_page.dart';
import 'blocs/bloc_exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init the hive
  await Hive.initFlutter();
  Hive.registerAdapter(todolistAdapter());
  // Open a box
  var box = await Hive.openBox<List>('mybox');

  BlocOverrides.runZoned(
    () => runApp(
      MyApp(),
    ),
  );

  // runApp(const MyApp())
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
      ),
    );
  }
}
