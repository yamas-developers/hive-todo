import 'package:flutter/material.dart';
import '../main.dart';
import '../models/task.dart';
import '../utils/constanst.dart';

class ModifyTask extends StatefulWidget {
  const ModifyTask({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task? task;

  @override
  State<ModifyTask> createState() => _ModifyTaskState();
}

class _ModifyTaskState extends State<ModifyTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.task?.name ?? '';
    descriptionController.text = widget.task?.description ?? '';
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        shouldProceed = titleController.text.isNotEmpty;
      });
    });
  }

  bool get tasksExists => widget.task != null;

  bool shouldProceed = false;

  dynamic submit() {
    if (titleController.text.isNotEmpty) {
      if (widget.task != null) {
        widget.task?.name = titleController.text;
        widget.task?.description = descriptionController.text;
        widget.task?.save();
        Navigator.of(context).pop();
      } else {
        var task = Task.create(
          name: titleController.text,
          description: descriptionController.text,
        );
        BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.of(context).pop();
      }
    } else {
      showSnackbar(context, 'Name can not be empty');
    }
  }

  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(tasksExists ? 'Update Task' : 'Add Task'),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              _buildContent(),
              const SizedBox(
                height: 50,
              ),
              _buildBottom(context),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Please enter all the information below',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Text('Enter task name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: titleController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.title, color: Colors.grey),
              hintText: 'Enter task name',
              enabledBorder: textfieldBorder,
              focusedBorder: textfieldBorder,
            ),
            onFieldSubmitted: (value) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onChanged: (value) {
              setState(() {
                shouldProceed = titleController.text.isNotEmpty;
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Text('Enter task description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: descriptionController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.description, color: Colors.grey),
              hintText: 'Enter task description',
              enabledBorder: textfieldBorder,
              focusedBorder: textfieldBorder,
            ),
            onFieldSubmitted: (value) {},
            onChanged: (value) {},
          ),
          if (widget.task?.createdAt != null)
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text('Created on', style: TextStyle()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(showDate((widget.task?.createdAt)!),
                        style: TextStyle()),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Padding _buildBottom(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: !tasksExists
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          !tasksExists
              ? Container()
              : Container(
                  width: 150,
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(color: primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minWidth: 150,
                    height: 55,
                    onPressed: () {
                      deleteTask();
                      Navigator.pop(context);
                    },
                    color: Colors.white,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.close,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Delete Task',
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            minWidth: 150,
            height: 55,
            onPressed: () {
              if (shouldProceed) submit();
            },
            color: shouldProceed ? primaryColor : Colors.grey,
            child: Text(
              !tasksExists ? 'Add Task' : 'Update Task',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
