// teacher_list_screen.dart
import 'package:flutter/material.dart';

class TeacherListScreen extends StatelessWidget {
  const TeacherListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample teacher data
    final List<Map<String, dynamic>> teachers = [
      {
        'name': 'Dr. Sarah Johnson',
        'department': 'Computer Science',
        'available': true,
        'image': 'assets/teacher1.png',
        'appointmentsBooked': 4,
      },
      {
        'name': 'Prof. Michael Chen',
        'department': 'Mathematics',
        'available': true,
        'image': 'assets/teacher2.png',
        'appointmentsBooked': 8,
      },
      {
        'name': 'Dr. Emily Rodriguez',
        'department': 'Physics',
        'available': false,
        'image': 'assets/teacher3.png',
        'appointmentsBooked': 10,
      },
      {
        'name': 'Prof. David Williams',
        'department': 'Engineering',
        'available': true,
        'image': 'assets/teacher4.png',
        'appointmentsBooked': 2,
      },
      {
        'name': 'Dr. James Taylor',
        'department': 'Biology',
        'available': true,
        'image': 'assets/teacher5.png',
        'appointmentsBooked': 6,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter functionality
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select a Teacher',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          // Department filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All Departments'),
                  selected: true,
                  onSelected: (bool selected) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Computer Science'),
                  selected: false,
                  onSelected: (bool selected) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Mathematics'),
                  selected: false,
                  onSelected: (bool selected) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Physics'),
                  selected: false,
                  onSelected: (bool selected) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Teacher list
          Expanded(
            child: ListView.builder(
              itemCount: teachers.length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, index) {
                final teacher = teachers[index];
                return TeacherCard(
                  name: teacher['name'],
                  department: teacher['department'],
                  isAvailable: teacher['available'],
                  image: teacher['image'],
                  appointmentsBooked: teacher['appointmentsBooked'],
                  onTap: () {
                    if (teacher['available'] && teacher['appointmentsBooked'] < 10) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentBookingScreen(teacher: teacher),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TeacherCard extends StatelessWidget {
  final String name;
  final String department;
  final bool isAvailable;
  final String image;
  final int appointmentsBooked;
  final VoidCallback onTap;

  const TeacherCard({
    Key? key,
    required this.name,
    required this.department,
    required this.isAvailable,
    required this.image,
    required this.appointmentsBooked,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool canBook = isAvailable && appointmentsBooked < 10;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: canBook ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(image),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      department,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isAvailable ? Colors.green.shade50 : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isAvailable ? Icons.check_circle : Icons.cancel,
                                size: 16,
                                color: isAvailable ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isAvailable ? 'Available' : 'Not Available',
                                style: TextStyle(
                                  color: isAvailable ? Colors.green : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.people,
                                size: 16,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$appointmentsBooked/10 booked',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (canBook)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// appointment_booking_screen.dart
class AppointmentBookingScreen extends StatefulWidget {
  final Map<String, dynamic> teacher;

  const AppointmentBookingScreen({
    Key? key,
    required this.teacher,
  }) : super(key: key);

  @override
  _AppointmentBookingScreenState createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedTimeSlot;
  final TextEditingController reasonController = TextEditingController();

  final List<String> availableTimeSlots = [
    '9:00 AM - 9:30 AM',
    '9:30 AM - 10:00 AM',
    '10:00 AM - 10:30 AM',
    '10:30 AM - 11:00 AM',
    '11:00 AM - 11:30 AM',
    '11:30 AM - 12:00 PM',
    '2:00 PM - 2:30 PM',
    '2:30 PM - 3:00 PM',
    '3:00 PM - 3:30 PM',
    '3:30 PM - 4:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book with ${widget.teacher['name']}'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teacher info
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(widget.teacher['image']),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.teacher['name'],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.teacher['department'],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.teacher['appointmentsBooked']}/10 appointments booked today',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Text(
              'Select Date',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Date selection
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7, // Show next 7 days
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final isSelected = selectedDate.day == date.day &&
                      selectedDate.month == date.month &&
                      selectedDate.year == date.year;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                        selectedTimeSlot = null; // Reset time slot when date changes
                      });
                    },
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                              fontSize: 22,
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.month}/${date.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.white : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
            Text(
              'Select Time Slot',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Time slots
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: availableTimeSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = availableTimeSlots[index];
                final isSelected = selectedTimeSlot == timeSlot;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTimeSlot = timeSlot;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      timeSlot,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
            Text(
              'Reason for Appointment',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Reason field
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Briefly describe why you need this appointment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 24),

            // Book button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedTimeSlot != null ? () {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Confirm Appointment'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Teacher: ${widget.teacher['name']}'),
                          const SizedBox(height: 8),
                          Text('Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                          const SizedBox(height: 8),
                          Text('Time: $selectedTimeSlot'),
                          const SizedBox(height: 8),
                          Text('Reason: ${reasonController.text}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Here you would save the appointment to your database

                            // Show success message and return to previous screen
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Appointment booked successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Navigate back twice (to the main screen)
                            Navigator.pop(context); // Close dialog
                            Navigator.pop(context); // Back to teacher list
                          },
                          child: Text('Confirm'),
                        ),
                      ],
                    ),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

