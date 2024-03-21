import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/view/tasks_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constanst.dart';

class EnterNameScreen extends StatefulWidget {
  EnterNameScreen({Key? key}) : super(key: key);

  @override
  State<EnterNameScreen> createState() => _EnterNameScreenState();
}

class _EnterNameScreenState extends State<EnterNameScreen> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> setUserName() async {
    if (_nameController.text.length < 3) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUserName, _nameController.text);
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (ctx) => TasksScreeen(
          name: _nameController.text,
        ),
      ),
      (route) => false,
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String? name = await loadUserName();
      _nameController.text = name ?? '';
      setState(() {
        shouldProceed = _nameController.text.length >= 3;
      });
    });
    super.initState();
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool shouldProceed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Your Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enter your name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.title, color: Colors.grey),
                  hintText: 'Enter your name',
                  enabledBorder: textfieldBorder,
                  focusedBorder: textfieldBorder,
                  errorBorder: textfieldBorder.copyWith(
                      borderSide: const BorderSide(
                    color: Colors.red,
                  )),
                  focusedErrorBorder: textfieldBorder.copyWith(
                      borderSide: const BorderSide(
                    color: Colors.red,
                  )),
                ),
                onFieldSubmitted: (value) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  setState(() {
                    shouldProceed = _nameController.text.length >= 3;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  } else if (value.length < 3) {
                    return 'Name must be at least 3 characters';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 36),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minWidth: 150,
                height: 55,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setUserName();
                  }
                },
                color: shouldProceed ? primaryColor : Colors.grey.shade300,
                child: Text(
                  'Save',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
