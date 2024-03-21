import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color primaryColor = Colors.teal;

const String keyUserName = 'username';

InputBorder textfieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(color: Colors.grey.shade300),
);

showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 2000),
    ),
  );
}

String showDate(DateTime date) {
  return DateFormat('MMM dd, yyyy hh:mm a').format(date).toString();
}

Future<String?> loadUserName() async {
  final prefs = await SharedPreferences.getInstance();
  // prefs.remove(keyUserName);
  String? name = prefs.getString(keyUserName);
  return name;
}
