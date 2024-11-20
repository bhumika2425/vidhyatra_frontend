import 'package:flutter/material.dart';

class WeeklyRoutinePage extends StatelessWidget {
  final List<Map<String, String>> routine = [
    // Sample routine data
    {
      'day': 'Monday',
      'time': '9:00 AM - 10:30 AM',
      'className': 'CS101',
      'moduleName': 'Computer Science Fundamentals',
      'teacherName': 'Mr. John'
    },
    {
      'day': 'Tuesday',
      'time': '11:00 AM - 12:30 PM',
      'className': 'CS102',
      'moduleName': 'Programming Basics',
      'teacherName': 'Ms. Smith'
    },
    {
      'day': 'Wednesday',
      'time': '1:00 PM - 2:30 PM',
      'className': 'CS103',
      'moduleName': 'Data Structures',
      'teacherName': 'Dr. Lee'
    },
    // Add more entries for other days and times
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Academic Routine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: routine.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.schedule),
                title: Text(
                  '${routine[index]['className']} - ${routine[index]['moduleName']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Day: ${routine[index]['day']}\n'
                      'Time: ${routine[index]['time']}\n'
                      'Teacher: ${routine[index]['teacherName']}',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}