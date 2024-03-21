import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../main.dart';
import '../models/task.dart';
import 'modify_task.dart';
import 'name_screen.dart';
import 'widgets/task_widget.dart';

class TasksScreeen extends StatefulWidget {
  const TasksScreeen({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  _TasksScreeenState createState() => _TasksScreeenState();
}

class _TasksScreeenState extends State<TasksScreeen> {
  int checkDoneTask(List<Task> task) {
    int i = 0;
    for (Task doneTasks in task) {
      if (doneTasks.isDone) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    final base = BaseWidget.of(context);

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();
          tasks.sort(
            ((b, a) => a.createdAt.compareTo(b.createdAt)),
          );

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Hello ${widget.name}!'),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => EnterNameScreen(),
                    ));
                  },
                  icon: const Icon(Icons.person),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const ModifyTask(
                      task: null,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            body: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Texts
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Your Tasks',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                  "${checkDoneTask(tasks)} of ${tasks.length} task",
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),

                    /// Divider
                    Divider(
                      indent: 20,
                      endIndent: 20,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                      child: tasks.isNotEmpty
                          ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: tasks.length,
                              itemBuilder: (BuildContext context, int index) {
                                var task = tasks[index];

                                return Dismissible(
                                  direction: DismissDirection.horizontal,
                                  background: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text('This task will be deleted',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ))
                                    ],
                                  ),
                                  onDismissed: (direction) {
                                    base.dataStore.dalateTask(task: task);
                                  },
                                  key: UniqueKey(),
                                  child: TaskWidget(
                                    task: tasks[index],
                                  ),
                                );
                              },
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No Tasks to show',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
