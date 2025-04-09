import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/tryController.dart';


class DashboardView extends GetView<DashboardController> {
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.blue, // Blue theme for AppBar
        foregroundColor: Colors.white, // White text/icons
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Get.snackbar('Notifications', 'Coming soon!');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(constraints.maxWidth * 0.04),
              color: Colors.white, // White background
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(context, constraints),
                  // SizedBox(height: constraints.maxHeight * 0.03),
                  // _buildStatusCards(context, constraints),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  _buildFeaturesGrid(context, constraints),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, BoxConstraints constraints) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.02),
      child: Row(
        children: [
          CircleAvatar(
            radius: constraints.maxWidth * 0.08,
            backgroundImage: const AssetImage('assets/images/teacher_avatar.png'),
            backgroundColor: Colors.blue.shade100, // Light blue fallback
            child: controller.teacherName.value.isNotEmpty
                ? null
                : Text(
              'TP',
              style: TextStyle(
                fontSize: constraints.maxWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800, // Dark blue text
              ),
            ),
          ),
          SizedBox(width: constraints.maxWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                  'Welcome, ${controller.teacherName}!',
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800, // Dark blue
                  ),
                )),
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.035,
                    color: Colors.blue.shade600, // Medium blue
                  ),
                ),
                Obx(() => Text(
                  controller.teacherDepartment.value,
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.04,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue.shade600, // Medium blue
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCards(BuildContext context, BoxConstraints constraints) {
    return SizedBox(
      height: constraints.maxHeight * 0.15,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildStatusCard(
            context,
            'Today\'s Classes',
            controller.todayClassesCount.toString(),
            Icons.school,
            Colors.blue,
            constraints,
          ),
          _buildStatusCard(
            context,
            'Pending Appointments',
            controller.pendingAppointmentsCount.toString(),
            Icons.schedule,
            Colors.blue,
            constraints,
          ),
          _buildStatusCard(
            context,
            'Unread Messages',
            controller.unreadMessagesCount.toString(),
            Icons.email,
            Colors.blue,
            constraints,
          ),
          _buildStatusCard(
            context,
            'Upcoming Deadlines',
            controller.upcomingDeadlinesCount.toString(),
            Icons.alarm,
            Colors.blue,
            constraints,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
      BuildContext context,
      String title,
      String count,
      IconData icon,
      Color color,
      BoxConstraints constraints,
      ) {
    return Container(
      width: constraints.maxWidth * 0.35,
      margin: EdgeInsets.only(right: constraints.maxWidth * 0.04),
      padding: EdgeInsets.all(constraints.maxWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.blue.shade50, // Very light blue background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200), // Light blue border
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.blue.shade800, size: constraints.maxWidth * 0.05),
              SizedBox(width: constraints.maxWidth * 0.02),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: constraints.maxWidth * 0.035,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: constraints.maxHeight * 0.01),
          Text(
            count,
            style: TextStyle(
              fontSize: constraints.maxWidth * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context, BoxConstraints constraints) {
    final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: constraints.maxWidth * 0.04,
      mainAxisSpacing: constraints.maxHeight * 0.03,
      childAspectRatio: constraints.maxWidth / (constraints.maxHeight * 0.8),
      children: [
        _buildFeatureCard(
          context,
          'Appointments',
          Icons.calendar_today,
          Colors.blue,
              () => Get.to(() => AppointmentsView()),
          'Set appointment slots for students to book consultation hours',
          constraints,
        ),
        _buildFeatureCard(
          context,
          'Calendar',
          Icons.event,
          Colors.blue,
              () => Get.to(() => CalendarView()),
          'View your schedule, classes, and upcoming events',
          constraints,
        ),
        _buildFeatureCard(
          context,
          'Messages',
          Icons.message,
          Colors.blue,
              () => Get.to(() => MessagesView()),
          'Communicate with students and colleagues in real-time',
          constraints,
        ),
        _buildFeatureCard(
          context,
          'Deadlines',
          Icons.assignment_late,
          Colors.blue,
              () => Get.to(() => DeadlinesView()),
          'Create and manage assignment deadlines for your courses',
          constraints,
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      VoidCallback onPressed,
      String description,
      BoxConstraints constraints,
      ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.blue.shade50, // Light blue gradient
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(constraints.maxWidth * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(constraints.maxWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100, // Light blue circle
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: constraints.maxWidth * 0.12,
                  color: Colors.blue.shade800, // Dark blue icon
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.02),
              Text(
                title,
                style: TextStyle(
                  fontSize: constraints.maxWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.01),
              Flexible(
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.035,
                    color: Colors.blue.shade600, // Medium blue
                  ),
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Open',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: constraints.maxWidth * 0.035,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: constraints.maxWidth * 0.04,
                    color: Colors.blue.shade800,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue, Colors.blue.shade800], // Blue gradient
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: constraints.maxWidth * 0.12,
                      backgroundImage: const AssetImage('assets/images/teacher_avatar.png'),
                      backgroundColor: Colors.blue.shade100, // Light blue fallback
                      child: controller.teacherName.value.isNotEmpty
                          ? null
                          : Text(
                        'TP',
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text
                        ),
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.015),
                    Obx(() => Text(
                      controller.teacherName.value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: constraints.maxWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    Obx(() => Text(
                      controller.teacherEmail.value,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: constraints.maxWidth * 0.045,
                      ),
                    )),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.blue),
                title: const Text('My Profile'),
                onTap: () {
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.blue),
                title: const Text('Account Settings'),
                onTap: () {
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(Icons.school, color: Colors.blue),
                title: const Text('My Courses'),
                onTap: () {
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(Icons.badge, color: Colors.blue),
                title: const Text('Office Hours'),
                onTap: () {
                  Get.back();
                },
              ),
              Divider(color: Colors.blue.shade200),
              ListTile(
                leading: const Icon(Icons.help_outline, color: Colors.blue),
                title: const Text('Help & Support'),
                onTap: () {
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.blue),
                title: const Text('Logout'),
                onTap: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                            // controller.logout();
                          },
                          child: const Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Blue button
                            foregroundColor: Colors.white, // White text
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}


class AppointmentsView extends GetView<AppointmentsController> {
  final AppointmentsController controller = Get.put(AppointmentsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        centerTitle: true,
      ),
      body: Obx(() => controller.appointments.isEmpty
          ? Center(child: Text('No appointments yet'))
          : ListView.builder(
        itemCount: controller.appointments.length,
        itemBuilder: (context, index) {
          final appointment = controller.appointments[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(appointment.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat('MMM dd, yyyy')
                      .format(appointment.date)),
                  Text(
                      '${appointment.startTime} - ${appointment.endTime}'),
                  Text('Location: ${appointment.location}'),
                  // Continuing from appointments_view.dart ListTile subtitle
                  Text('Status: ${appointment.status.capitalizeFirst}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: appointment.status == 'booked'
                          ? Colors.green[100]
                          : Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      appointment.status.capitalizeFirst!,
                      style: TextStyle(
                        color: appointment.status == 'booked'
                            ? Colors.green[800]
                            : Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        controller.deleteAppointment(appointment.id),
                  ),
                ],
              ),
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateAppointmentDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Create New Appointment',
      ),
    );
  }

  void _showCreateAppointmentDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create New Appointment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              InkWell(
                onTap: controller.selectDate,
                child: TextField(
                  controller: controller.dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  enabled: false,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: controller.selectStartTime,
                      child: TextField(
                        controller: controller.startTimeController,
                        decoration: InputDecoration(
                          labelText: 'Start Time',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        enabled: false,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: controller.selectEndTime,
                      child: TextField(
                        controller: controller.endTimeController,
                        decoration: InputDecoration(
                          labelText: 'End Time',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        enabled: false,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              TextField(
                controller: controller.locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: controller.createAppointment,
                    child: Text('Create'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 80,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Calendar Feature',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'This is a placeholder for the existing calendar feature.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: (){},
              // onPressed: controller.navigateToCalendar,
              child: Text('Go to Calendar'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesView extends GetView<MessagesController> {
  final MessagesController controller = Get.put(MessagesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        centerTitle: true,
      ),
      body: Row(
        children: [
          // Conversation list
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Obx(() => controller.conversations.isEmpty
                ? Center(child: Text('No conversations'))
                : ListView.builder(
              itemCount: controller.conversations.length,
              itemBuilder: (context, index) {
                final user = controller.conversations[index];
                return Obx(() => ListTile(
                  leading: CircleAvatar(
                    child: Text(user.name[0]),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  selected: controller.selectedConversation.value?.id == user.id,
                  selectedTileColor: Colors.grey[100],
                  onTap: () => controller.selectConversation(user),
                ));
              },
            )),
          ),
          // Message thread
          Expanded(
            child: Obx(() => controller.selectedConversation.value == null
                ? Center(child: Text('Select a conversation to start messaging'))
                : Column(
              children: [
                // Conversation header
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        child: Text(controller.selectedConversation.value!.name[0]),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.selectedConversation.value!.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            controller.selectedConversation.value!.email,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Messages
                Expanded(
                  child: Obx(() => controller.messages.isEmpty
                      ? Center(child: Text('No messages yet'))
                      : ListView.builder(
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      final isMyMessage = message.senderId == controller.currentTeacherId.value;

                      return Align(
                        alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.5,
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMyMessage ? Colors.blue[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(message.content),
                              SizedBox(height: 4),
                              Text(
                                DateFormat('hh:mm a').format(message.timestamp),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
                ),
                // Message input
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          onSubmitted: (_) => controller.sendMessage(),
                        ),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          icon: Icon(Icons.send, color: Colors.white),
                          onPressed: controller.sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}

class DeadlinesView extends GetView<DeadlinesController> {
  final DeadlinesController controller = Get.put(DeadlinesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deadlines'),
        centerTitle: true,
      ),
      body: Obx(() => controller.deadlines.isEmpty
          ? Center(child: Text('No deadlines yet'))
          : ListView.builder(
        itemCount: controller.deadlines.length,
        itemBuilder: (context, index) {
          final deadline = controller.deadlines[index];
          final isUpcoming = deadline.dueDate.isAfter(DateTime.now());
          final daysLeft = deadline.dueDate.difference(DateTime.now()).inDays;

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(deadline.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(deadline.description),
                  Text('Subject: ${deadline.subjectId}'),
                  Text('Due: ${DateFormat('MMM dd, yyyy').format(deadline.dueDate)}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUpcoming
                          ? (daysLeft <= 3 ? Colors.orange[100] : Colors.green[100])
                          : Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isUpcoming
                          ? daysLeft == 0
                          ? 'Due Today!'
                          : daysLeft == 1
                          ? '1 day left'
                          : '$daysLeft days left'
                          : 'Overdue',
                      style: TextStyle(
                        color: isUpcoming
                            ? (daysLeft <= 3 ? Colors.orange[800] : Colors.green[800])
                            : Colors.red[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.deleteDeadline(deadline.id),
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDeadlineDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Create New Deadline',
      ),
    );
  }

  void _showCreateDeadlineDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create New Deadline',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: controller.descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 12),
              InkWell(
                onTap: controller.selectDueDate,
                child: TextField(
                  controller: controller.dueDateController,
                  decoration: InputDecoration(
                    labelText: 'Due Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  enabled: false,
                ),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: controller.selectedSubject.value.isEmpty
                    ? null
                    : controller.selectedSubject.value,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
                items: controller.subjects.map((subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.setSubject(value);
                  }
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: controller.createDeadline,
                    child: Text('Create'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}