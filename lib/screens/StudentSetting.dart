// import 'package:flutter/material.dart';
//
// class Studentsetting extends StatelessWidget {

//   const Studentsetting({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {

//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/IconController.dart';

class Studentsetting extends StatefulWidget {
  const Studentsetting({super.key});

  @override
  State<Studentsetting> createState() => _StudentsettingState();
}

class _StudentsettingState extends State<Studentsetting> {
  bool isDarkMode = false; // Track the current theme mode
  final IconController iconController = Get.put(IconController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(Icons.dark_mode),
          ),
          Text('Dark mode'),
          SizedBox(width: 10),
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
              if (isDarkMode) {
                Get.changeTheme(ThemeData.dark());
              } else {
                Get.changeTheme(ThemeData.light());
              }
            },
          ),
        ],
      ),
    );
  }
}

