import 'package:flutter/material.dart';

class AssignmentPage extends StatelessWidget {
  // Sample assignment data
  final List<Map<String, String>> assignments = [
    {
      'title': 'Math Assignment 1',
      'dueDate': '2024-12-25',
      'status': 'Pending',
    },
    {
      'title': 'Physics Assignment 2',
      'dueDate': '2024-12-30',
      'status': 'Completed',
    },
    {
      'title': 'Chemistry Assignment 3',
      'dueDate': '2024-12-28',
      'status': 'Pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Placeholder for search functionality
              showSearch(context: context, delegate: AssignmentSearchDelegate());
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Assignments',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            // List of assignments
            Expanded(
              child: ListView.builder(
                itemCount: assignments.length,
                itemBuilder: (context, index) {
                  final assignment = assignments[index];
                  return AssignmentCard(
                    title: assignment['title']!,
                    dueDate: assignment['dueDate']!,
                    status: assignment['status']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AssignmentCard extends StatelessWidget {
  final String title;
  final String dueDate;
  final String status;

  AssignmentCard({
    required this.title,
    required this.dueDate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.assignment,
              color: Colors.blue,
              size: 40,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Due Date: $dueDate',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Status: $status',
                    style: TextStyle(
                      fontSize: 14,
                      color: status == 'Completed' ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                // Placeholder for view details button
                showDialog(
                  context: context,
                  builder: (context) => AssignmentDetailDialog(
                    title: title,
                    dueDate: dueDate,
                    status: status,
                  ),
                );
              },
              child: Text('View Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AssignmentDetailDialog extends StatelessWidget {
  final String title;
  final String dueDate;
  final String status;

  AssignmentDetailDialog({
    required this.title,
    required this.dueDate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Assignment Details'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Title: $title', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Due Date: $dueDate'),
          SizedBox(height: 8),
          Text('Status: $status'),
          SizedBox(height: 8),
          // Add more details here (e.g., description, instructions)
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
      ],
    );
  }
}

class AssignmentSearchDelegate extends SearchDelegate<String> {
  final List<String> searchTerms = ['Math', 'Physics', 'Chemistry']; // Sample search data

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = searchTerms
        .where((term) => term.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView(
      children: results.map((term) => ListTile(title: Text(term))).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = searchTerms
        .where((term) => term.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView(
      children: suggestions.map((term) => ListTile(title: Text(term))).toList(),
    );
  }
}
