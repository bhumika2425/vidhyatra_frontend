import 'package:get/get.dart';
import '../models/exam.dart';
import '../models/classroom.dart';
import '../models/seat_allocation.dart';

class ExamSeatController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var exams = <Exam>[].obs;
  var classrooms = <Classroom>[].obs;
  var seatAllocations = <SeatAllocation>[].obs;
  var mySeatAllocations = <SeatAllocation>[].obs;
  var selectedExam = Rx<Exam?>(null);
  var selectedClassroom = Rx<Classroom?>(null);

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  // Load dummy data for demonstration
  void loadDummyData() {
    // Dummy Classrooms
    classrooms.value = [
      Classroom(
        classroomId: 1,
        name: "Room A",
        capacity: 40,
        rows: 5,
        seatsPerRow: 8,
        isAvailable: true,
        location: "Ground Floor, East Wing",
      ),
      Classroom(
        classroomId: 2,
        name: "Room B",
        capacity: 35,
        rows: 5,
        seatsPerRow: 7,
        isAvailable: true,
        location: "First Floor, West Wing",
      ),
      Classroom(
        classroomId: 3,
        name: "Room C",
        capacity: 30,
        rows: 6,
        seatsPerRow: 5,
        isAvailable: true,
        location: "Ground Floor, Center",
      ),
      Classroom(
        classroomId: 4,
        name: "Lab 1",
        capacity: 25,
        rows: 5,
        seatsPerRow: 5,
        isAvailable: true,
        location: "Second Floor, Tech Wing",
      ),
      Classroom(
        classroomId: 5,
        name: "Auditorium",
        capacity: 100,
        rows: 10,
        seatsPerRow: 10,
        isAvailable: false,
        location: "Third Floor, Main Building",
      ),
    ];

    // Dummy Exams
    exams.value = [
      Exam(
        examId: 1,
        moduleName: "Software Engineering",
        moduleCode: "SE-301",
        examDate: DateTime.now().add(Duration(days: 7)),
        startTime: "09:00 AM",
        endTime: "12:00 PM",
        duration: 180,
        year: "3rd Year",
        semester: "6th Semester",
        totalStudents: 85,
        status: "published",
        examType: "final",
      ),
      Exam(
        examId: 2,
        moduleName: "Database Management",
        moduleCode: "DB-302",
        examDate: DateTime.now().add(Duration(days: 10)),
        startTime: "01:00 PM",
        endTime: "04:00 PM",
        duration: 180,
        year: "3rd Year",
        semester: "6th Semester",
        totalStudents: 78,
        status: "scheduled",
        examType: "final",
      ),
      Exam(
        examId: 3,
        moduleName: "Data Structures",
        moduleCode: "DS-201",
        examDate: DateTime.now().add(Duration(days: 5)),
        startTime: "10:00 AM",
        endTime: "01:00 PM",
        duration: 180,
        year: "2nd Year",
        semester: "4th Semester",
        totalStudents: 92,
        status: "published",
        examType: "midterm",
      ),
      Exam(
        examId: 4,
        moduleName: "Object Oriented Programming",
        moduleCode: "OOP-202",
        examDate: DateTime.now().add(Duration(days: 14)),
        startTime: "09:00 AM",
        endTime: "11:00 AM",
        duration: 120,
        year: "2nd Year",
        semester: "4th Semester",
        totalStudents: 88,
        status: "scheduled",
        examType: "sessional",
      ),
    ];

    // Dummy Seat Allocations (for current user)
    mySeatAllocations.value = [
      SeatAllocation(
        allocationId: 1,
        examId: 1,
        studentId: 66, // Current user's ID
        studentName: "Bhumika K.C.",
        rollNumber: "22068966",
        classroomId: 1,
        classroomName: "Room A",
        seatNumber: 15,
        rowNumber: 2,
        position: "center",
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        isPublished: true,
      ),
      SeatAllocation(
        allocationId: 3,
        examId: 3,
        studentId: 66,
        studentName: "Bhumika K.C.",
        rollNumber: "22068966",
        classroomId: 2,
        classroomName: "Room B",
        seatNumber: 8,
        rowNumber: 1,
        position: "right",
        createdAt: DateTime.now().subtract(Duration(hours: 6)),
        isPublished: true,
      ),
    ];
  }

  // Get upcoming exams for student
  Future<void> getUpcomingExams() async {
    try {
      isLoading.value = true;
      
      // Simulate API call with dummy data
      await Future.delayed(Duration(milliseconds: 800));
      
      // Filter exams that are upcoming
      var upcomingExams = exams.where((exam) => 
        exam.examDate.isAfter(DateTime.now().subtract(Duration(days: 1)))
      ).toList();
      
      exams.value = upcomingExams;
      
      Get.snackbar(
        "Success", 
        "Loaded ${upcomingExams.length} upcoming exams",
        snackPosition: SnackPosition.TOP,
      );
      
    } catch (error) {
      Get.snackbar(
        "Error", 
        "Failed to load exams: ${error.toString()}",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get seat allocation for specific exam and student
  Future<SeatAllocation?> getMySeatForExam(int examId) async {
    try {
      isLoading.value = true;
      
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 500));
      
      // Find seat allocation for this exam
      var seatAllocation = mySeatAllocations.firstWhereOrNull(
        (allocation) => allocation.examId == examId && allocation.isPublished
      );
      
      return seatAllocation;
      
    } catch (error) {
      Get.snackbar(
        "Error", 
        "Failed to get seat allocation: ${error.toString()}",
        snackPosition: SnackPosition.TOP,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Search seat allocation by roll number
  Future<SeatAllocation?> searchSeatAllocation(int examId, String rollNumber) async {
    try {
      isLoading.value = true;
      
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 600));
      
      // Generate dummy seat allocation for search
      if (rollNumber.isNotEmpty) {
        var exam = exams.firstWhereOrNull((e) => e.examId == examId);
        var classroom = classrooms.first;
        
        if (exam != null) {
          var searchResult = SeatAllocation(
            allocationId: 999,
            examId: examId,
            studentId: 999,
            studentName: "Student with Roll: $rollNumber",
            rollNumber: rollNumber,
            classroomId: classroom.classroomId,
            classroomName: classroom.name,
            seatNumber: (rollNumber.hashCode % 30) + 1,
            rowNumber: ((rollNumber.hashCode % 5) + 1),
            position: "center",
            createdAt: DateTime.now(),
            isPublished: true,
          );
          
          return searchResult;
        }
      }
      
      return null;
      
    } catch (error) {
      Get.snackbar(
        "Error", 
        "Failed to search seat: ${error.toString()}",
        snackPosition: SnackPosition.TOP,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Get all classrooms
  Future<void> getAllClassrooms() async {
    try {
      isLoading.value = true;
      
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 400));
      
      // Data already loaded in loadDummyData()
      Get.snackbar(
        "Success", 
        "Loaded ${classrooms.length} classrooms",
        snackPosition: SnackPosition.TOP,
      );
      
    } catch (error) {
      Get.snackbar(
        "Error", 
        "Failed to load classrooms: ${error.toString()}",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get classroom layout
  Classroom? getClassroomById(int classroomId) {
    return classrooms.firstWhereOrNull((classroom) => classroom.classroomId == classroomId);
  }

  // Get exam by ID
  Exam? getExamById(int examId) {
    return exams.firstWhereOrNull((exam) => exam.examId == examId);
  }

  // Filter exams by status
  List<Exam> getExamsByStatus(String status) {
    return exams.where((exam) => exam.status == status).toList();
  }

  // Get published seat allocations count
  int getPublishedSeatsCount() {
    return mySeatAllocations.where((allocation) => allocation.isPublished).length;
  }
}
