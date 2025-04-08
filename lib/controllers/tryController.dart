
// CONTROLLERS
// app/modules/dashboard/controllers/dashboard_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class DashboardController extends GetxController {
  final currentTeacherId = 'teacher123'.obs;
  final appointments = <Appointment>[].obs;
  final messages = <Message>[].obs;
  final deadlines = <Deadline>[].obs;

  final teacherName = 'Dr. Emily Johnson'.obs;
  final teacherEmail = 'emily.johnson@university.edu'.obs;
  final teacherDepartment = 'Department of Computer Science'.obs;

  // Status cards counts
  final todayClassesCount = 3.obs;
  final pendingAppointmentsCount = 5.obs;
  final unreadMessagesCount = 12.obs;
  final upcomingDeadlinesCount = 8.obs;


  @override
  void onInit() {
    super.onInit();
    fetchRecentAppointments();
    fetchRecentMessages();
    fetchUpcomingDeadlines();
  }

  void fetchRecentAppointments() {
    // Mocked data fetch - in a real app, you'd call an API
    appointments.value = [
      Appointment(
        id: 'app1',
        title: 'Office Hours',
        date: DateTime.now().add(Duration(days: 1)),
        startTime: '10:00 AM',
        endTime: '11:00 AM',
        location: 'Room 203',
        availableForStudentIds: ['student1', 'student2'],
        teacherId: 'teacher123',
        status: 'available',
      ),
      Appointment(
        id: 'app2',
        title: 'Project Discussion',
        date: DateTime.now().add(Duration(days: 2)),
        startTime: '2:00 PM',
        endTime: '3:00 PM',
        location: 'Lab 101',
        availableForStudentIds: ['student3', 'student4'],
        teacherId: 'teacher123',
        bookedByStudentId: 'student3',
        status: 'booked',
      ),
    ];
  }

  void fetchRecentMessages() {
    // Mocked data fetch
    messages.value = [
      Message(
        id: 'msg1',
        senderId: 'student1',
        receiverId: 'teacher123',
        content: 'Hello Professor, I have a question about today\'s lecture.',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isRead: true,
      ),
      Message(
        id: 'msg2',
        senderId: 'teacher123',
        receiverId: 'student1',
        content: 'Sure, what can I help you with?',
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        isRead: false,
      ),
    ];
  }

  void fetchUpcomingDeadlines() {
    // Mocked data fetch
    deadlines.value = [
      Deadline(
        id: 'dl1',
        title: 'Midterm Papers',
        description: 'Submit your research papers for midterm evaluation.',
        dueDate: DateTime.now().add(Duration(days: 5)),
        subjectId: 'subj1',
        teacherId: 'teacher123',
        forStudentIds: ['student1', 'student2', 'student3'],
      ),
      Deadline(
        id: 'dl2',
        title: 'Group Project Milestone',
        description: 'First draft of group project due.',
        dueDate: DateTime.now().add(Duration(days: 7)),
        subjectId: 'subj1',
        teacherId: 'teacher123',
        forStudentIds: ['student1', 'student2', 'student3', 'student4'],
      ),
    ];
  }
}

class MessagesController extends GetxController {
  final currentTeacherId = 'teacher123'.obs;
  final conversations = <User>[].obs;
  final selectedConversation = Rx<User?>(null);
  final messages = <Message>[].obs;

  final messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void fetchConversations() {
    // Fetch users that the teacher has messages with
    // Mocked data for now
    conversations.value = [
      User(
        id: 'student1',
        name: 'John Doe',
        email: 'john.doe@university.edu',
        role: 'student',
      ),
      User(
        id: 'student2',
        name: 'Jane Smith',
        email: 'jane.smith@university.edu',
        role: 'student',
      ),
    ];
  }

  void selectConversation(User user) {
    selectedConversation.value = user;
    fetchMessages(user.id);
  }

  void fetchMessages(String userId) {
    // Fetch messages between current teacher and selected user
    // Mocked data for now
    messages.value = [
      Message(
        id: 'msg1',
        senderId: userId,
        receiverId: currentTeacherId.value,
        content: 'Hello Professor, I have a question about today\'s lecture.',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isRead: true,
      ),
      Message(
        id: 'msg2',
        senderId: currentTeacherId.value,
        receiverId: userId,
        content: 'Sure, what can I help you with?',
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        isRead: true,
      ),
    ];
  }

  void sendMessage() {
    if (messageController.text.isEmpty || selectedConversation.value == null) {
      return;
    }

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentTeacherId.value,
      receiverId: selectedConversation.value!.id,
      content: messageController.text,
      timestamp: DateTime.now(),
      isRead: false,
    );

    // Add to list
    messages.add(newMessage);

    // Clear input
    messageController.clear();
  }
}

class DeadlinesController extends GetxController {
  final currentTeacherId = 'teacher123'.obs;
  final deadlines = <Deadline>[].obs;

  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dueDateController = TextEditingController();
  final subjectController = TextEditingController();

  final selectedDueDate = DateTime.now().add(Duration(days: 7)).obs;
  final subjects = ['Math 101', 'Physics 202', 'Computer Science 301'].obs;
  final selectedSubject = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeadlines();
    if (subjects.isNotEmpty) {
      selectedSubject.value = subjects[0];
      subjectController.text = subjects[0];
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    subjectController.dispose();
    super.onClose();
  }

  void fetchDeadlines() {
    // Fetch deadlines for the current teacher
    // Mocked data for now
    deadlines.value = [
      Deadline(
        id: 'dl1',
        title: 'Midterm Papers',
        description: 'Submit your research papers for midterm evaluation.',
        dueDate: DateTime.now().add(Duration(days: 5)),
        subjectId: 'Math 101',
        teacherId: 'teacher123',
        forStudentIds: ['student1', 'student2', 'student3'],
      ),
      Deadline(
        id: 'dl2',
        title: 'Group Project Milestone',
        description: 'First draft of group project due.',
        dueDate: DateTime.now().add(Duration(days: 7)),
        subjectId: 'Physics 202',
        teacherId: 'teacher123',
        forStudentIds: ['student1', 'student2', 'student3', 'student4'],
      ),
    ];
  }

  void createDeadline() {
    // Validate inputs first
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        dueDateController.text.isEmpty ||
        selectedSubject.value.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    // Create a new deadline
    final newDeadline = Deadline(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      description: descriptionController.text,
      dueDate: selectedDueDate.value,
      subjectId: selectedSubject.value,
      teacherId: currentTeacherId.value,
      forStudentIds: ['student1', 'student2', 'student3', 'student4'], // Simplified for demo
    );

    // Add to list
    deadlines.add(newDeadline);

    // Clear form
    titleController.clear();
    descriptionController.clear();
    dueDateController.clear();

    Get.back(); // Close creation form
    Get.snackbar('Success', 'Deadline created successfully');
  }

  void deleteDeadline(String id) {
    deadlines.removeWhere((deadline) => deadline.id == id);
    Get.snackbar('Success', 'Deadline deleted successfully');
  }

  void selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDueDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      selectedDueDate.value = picked;
      dueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void setSubject(String subject) {
    selectedSubject.value = subject;
    subjectController.text = subject;
  }
}


class AppointmentsController extends GetxController {
  final currentTeacherId = 'teacher123'.obs;
  final appointments = <Appointment>[].obs;

  // Form controllers
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final locationController = TextEditingController();

  final selectedDate = DateTime.now().obs;
  final selectedStartTime = TimeOfDay.now().obs;
  final selectedEndTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute).obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  @override
  void onClose() {
    titleController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    locationController.dispose();
    super.onClose();
  }

  void fetchAppointments() {
    // Fetch appointments for the current teacher
    // Mocked data for now
    appointments.value = [
      Appointment(
        id: 'app1',
        title: 'Office Hours',
        date: DateTime.now().add(Duration(days: 1)),
        startTime: '10:00 AM',
        endTime: '11:00 AM',
        location: 'Room 203',
        availableForStudentIds: ['student1', 'student2'],
        teacherId: 'teacher123',
        status: 'available',
      ),
      Appointment(
        id: 'app2',
        title: 'Project Discussion',
        date: DateTime.now().add(Duration(days: 2)),
        startTime: '2:00 PM',
        endTime: '3:00 PM',
        location: 'Lab 101',
        availableForStudentIds: ['student3', 'student4'],
        teacherId: 'teacher123',
        bookedByStudentId: 'student3',
        status: 'booked',
      ),
    ];
  }

  void createAppointment() {
    // Validate inputs first
    if (titleController.text.isEmpty ||
        dateController.text.isEmpty ||
        startTimeController.text.isEmpty ||
        endTimeController.text.isEmpty ||
        locationController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    // Create a new appointment
    final newAppointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      date: selectedDate.value,
      startTime: startTimeController.text,
      endTime: endTimeController.text,
      location: locationController.text,
      availableForStudentIds: ['student1', 'student2', 'student3', 'student4'], // Simplified for demo
      teacherId: currentTeacherId.value,
      status: 'available',
    );

    // Add to list
    appointments.add(newAppointment);

    // Clear form
    titleController.clear();
    dateController.clear();
    startTimeController.clear();
    endTimeController.clear();
    locationController.clear();

    Get.back(); // Close creation form
    Get.snackbar('Success', 'Appointment created successfully');
  }

  void deleteAppointment(String id) {
    appointments.removeWhere((appointment) => appointment.id == id);
    Get.snackbar('Success', 'Appointment deleted successfully');
  }

  void selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      selectedDate.value = picked;
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: selectedStartTime.value,
    );

    if (picked != null) {
      selectedStartTime.value = picked;
      startTimeController.text = _formatTimeOfDay(picked);
    }
  }

  void selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: selectedEndTime.value,
    );

    if (picked != null) {
      selectedEndTime.value = picked;
      endTimeController.text = _formatTimeOfDay(picked);
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}


class Appointment {
  final String id;
  final String title;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String location;
  final List<String> availableForStudentIds;
  final String teacherId;
  final String? bookedByStudentId;
  final String status; // 'available', 'booked', 'completed', 'cancelled'

  Appointment({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.availableForStudentIds,
    required this.teacherId,
    this.bookedByStudentId,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'availableForStudentIds': availableForStudentIds,
      'teacherId': teacherId,
      'bookedByStudentId': bookedByStudentId,
      'status': status,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      location: json['location'],
      availableForStudentIds: List<String>.from(json['availableForStudentIds']),
      teacherId: json['teacherId'],
      bookedByStudentId: json['bookedByStudentId'],
      status: json['status'],
    );
  }
}

// app/data/models/message_model.dart
class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.isRead,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'],
    );
  }
}

// app/data/models/deadline_model.dart
class Deadline {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String subjectId;
  final String teacherId;
  final List<String> forStudentIds;

  Deadline({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.subjectId,
    required this.teacherId,
    required this.forStudentIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'subjectId': subjectId,
      'teacherId': teacherId,
      'forStudentIds': forStudentIds,
    };
  }

  factory Deadline.fromJson(Map<String, dynamic> json) {
    return Deadline(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      subjectId: json['subjectId'],
      teacherId: json['teacherId'],
      forStudentIds: List<String>.from(json['forStudentIds']),
    );
  }
}

// app/data/models/user_model.dart
class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'teacher', 'student', 'admin'
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'profileImage': profileImage,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      profileImage: json['profileImage'],
    );
  }
}