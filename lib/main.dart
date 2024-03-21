//? CodeWithFlexz on Instagram

//* AmirBayat0 on Github
//! Programming with Flexz on Youtube

import 'package:flutter/material.dart';
import 'package:flutter_todo/utils/constanst.dart';
import 'package:flutter_todo/view/name_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/hive_data_store.dart';
import '../models/task.dart';
import 'view/tasks_screen.dart';

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter<Task>(TaskAdapter());

  await Hive.openBox<Task>(HiveDataStore.boxName);

  runApp(BaseWidget(child: const MyApp()));
}

class BaseWidget extends InheritedWidget {
  BaseWidget({Key? key, required this.child})
      : super(
          key: key,
          child: child,
        );
  final HiveDataStore dataStore = HiveDataStore();
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError('Could not find ancestor widget of type BaseWidget');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _userName;
  bool loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String? name = await loadUserName();
      setState(() {
        loading = false;
        _userName = name;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColor: Colors.teal,
          appBarTheme: const AppBarTheme(
            color: Colors.teal,
            foregroundColor: Colors.white,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.teal, foregroundColor: Colors.white)),
      home: loading
          ? Center(child: CircularProgressIndicator())
          : _userName == null
              ? EnterNameScreen()
              : TasksScreeen(
                  name: _userName!,
                ),
    );
  }
}
