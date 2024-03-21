import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/task.dart';
import '../../utils/constanst.dart';
import '../modify_task.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TextEditingController taskControllerForTitle = TextEditingController();
  TextEditingController taskControllerForSubtitle = TextEditingController();

  @override
  void initState() {
    super.initState();
    taskControllerForTitle.text = widget.task.name;
    taskControllerForSubtitle.text = widget.task.description;
  }

  @override
  void dispose() {
    taskControllerForTitle.dispose();
    taskControllerForSubtitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (ctx) => ModifyTask(
              task: widget.task,
            ),
          ),
        );

        setState(() {});
      },

      /// Main Card
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: widget.task.isDone
                ? const Color.fromARGB(200, 49, 162, 49)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  offset: const Offset(0, 4),
                  blurRadius: 10)
            ]),
        child: ListTile(
            leading: GestureDetector(
              onTap: () {
                widget.task.isDone = !widget.task.isDone;
                widget.task.save();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                decoration: BoxDecoration(
                    color: widget.task.isDone ? primaryColor : Colors.white,
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.grey, width: .8)),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ),

            /// title of Task
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 3),
              child: Text(
                taskControllerForTitle.text,
                style: TextStyle(
                  color: widget.task.isDone ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            /// Description of task
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (taskControllerForSubtitle.text.isNotEmpty)
                  Text(
                    taskControllerForSubtitle.text,
                    style: TextStyle(
                      color: widget.task.isDone
                          ? Colors.white
                          : const Color.fromARGB(255, 164, 164, 164),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      top: 10,
                    ),
                    child: Row(
                      children: [
                        if (widget.task.isDone)
                          Text(
                            'Completed',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: widget.task.isDone
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                        Spacer(),
                        Text(
                          showDate(widget.task.createdAt),
                          style: TextStyle(
                              fontSize: 12,
                              color: widget.task.isDone
                                  ? Colors.white
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
