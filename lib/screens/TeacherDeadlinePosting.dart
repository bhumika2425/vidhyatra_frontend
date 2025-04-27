import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeadlineHomePage extends StatefulWidget {
  const DeadlineHomePage({Key? key}) : super(key: key);

  @override
  _DeadlineHomePageState createState() => _DeadlineHomePageState();
}

class _DeadlineHomePageState extends State<DeadlineHomePage> {
  bool _showForm = false;

  // Sample data for deadlines
  final List<Map<String, dynamic>> _deadlines = [
    {
      'id': 1,
      'title': 'Coursework 1',
      'course': 'Application Development',
      'deadline': DateTime.now().add(Duration(days: 5)),
      'isCompleted': false,
      'createdAt': DateTime.now().subtract(Duration(days: 2)),
      'updatedAt': DateTime.now().subtract(Duration(days: 2)),
      'year': 'Third Year',
      'semester': '2'
    },
    {
      'id': 2,
      'title': 'Final Year Project',
      'course': 'Project Assessment',
      'deadline': DateTime.now().add(Duration(days: 10)),
      'isCompleted': true,
      'createdAt': DateTime.now().subtract(Duration(days: 5)),
      'updatedAt': DateTime.now().subtract(Duration(days: 1)),
      'year': '3rd Year',
      'semester': '2'
    },
    {
      'id': 3,
      'title': 'Week 2 Lab',
      'course': 'Software Engineering',
      'deadline': DateTime.now().add(Duration(days: 3)),
      'isCompleted': false,
      'createdAt': DateTime.now().subtract(Duration(days: 3)),
      'updatedAt': DateTime.now().subtract(Duration(days: 3)),
      'year': '2nd Year',
      'semester': '2'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Teacher Deadlines',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Status bar
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            color: Color(0xFF186CAC),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_deadlines.where((d) => d['isCompleted'] == true).length} Completed',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${_deadlines.where((d) => d['isCompleted'] == false).length} Pending',
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  icon: Icon(_showForm ? Icons.close : Icons.add, color: Colors.white),
                  label: Text(
                    _showForm ? 'Cancel' : 'Add New',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _showForm = !_showForm;
                    });
                  },
                ),
              ],
            ),
          ),

          // Add new deadline form
          if (_showForm)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Deadline',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF186CAC),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF186CAC)),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Course',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF186CAC)),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Deadline Date',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF186CAC)),
                          ),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Year',
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF186CAC)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Semester',
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF186CAC)),
                                ),
                              ),
                              items: ['Spring', 'Summer', 'Fall', 'Winter']
                                  .map((semester) => DropdownMenuItem(
                                value: semester,
                                child: Text(semester),
                              ))
                                  .toList(),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.deepOrange,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            'SAVE DEADLINE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Deadlines list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: _deadlines.length,
              itemBuilder: (context, index) {
                final deadline = _deadlines[index];
                final bool isCompleted = deadline['isCompleted'];

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isCompleted ? Colors.green.shade200 : Colors.orange.shade200,
                      width: 1,
                    ),
                  ),
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Row(
                          children: [
                            Text(
                              deadline['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isCompleted ? Colors.green.shade100 : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                isCompleted ? 'Completed' : 'Pending',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isCompleted ? Colors.green.shade700 : Colors.orange.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              'Course: ${deadline['course']}',
                              style: TextStyle(color: Colors.black87),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 14, color: Color(0xFF186CAC)),
                                SizedBox(width: 4),
                                Text(
                                  'Due: ${DateFormat('MMM dd, yyyy').format(deadline['deadline'])}',
                                  style: TextStyle(
                                    color: Color(0xFF186CAC),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${deadline['year']} - ${deadline['semester']}',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: Icon(
                                Icons.edit,
                                size: 16,
                                color: Color(0xFF186CAC),
                              ),
                              label: Text(
                                'Edit',
                                style: TextStyle(color: Color(0xFF186CAC)),
                              ),
                              onPressed: () {},
                            ),
                            TextButton.icon(
                              icon: Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: Colors.red,
                              ),
                              label: Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {},
                            ),
                            TextButton.icon(
                              icon: Icon(
                                isCompleted ? Icons.refresh : Icons.check_circle_outline,
                                size: 16,
                                color: isCompleted ? Colors.orange : Colors.green,
                              ),
                              label: Text(
                                isCompleted ? 'Mark Pending' : 'Mark Complete',
                                style: TextStyle(
                                  color: isCompleted ? Colors.orange : Colors.green,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}