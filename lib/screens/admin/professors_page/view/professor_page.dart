import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidhyatra_flutter/screens/admin/admin_students/controller/admin_students_controller.dart';
import 'package:vidhyatra_flutter/screens/admin/professors_page/controller/professor_controller.dart';

import '../../../../models/user.dart';

class ProfessorsPage extends StatelessWidget { // Changed to StatelessWidget since we're using GetX
  final ProfessorController controller = Get.put(ProfessorController());

  ProfessorsPage({super.key});

  void _showAddStudentDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final collegeIdController = TextEditingController();
    final roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Student'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: collegeIdController,
                decoration: const InputDecoration(labelText: 'College ID'),
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // final newStudent = User(
              //   userId: 0,
              //   collegeId: collegeIdController.text,
              //   name: nameController.text,
              //   email: emailController.text,
              //   role: roleController.text,
              //   createdAt: DateTime.now(),
              //   updatedAt: DateTime.now(),
              // );
              // controller.addStudent(newStudent);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Professors')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: () => controller.fetchProfessor(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (controller.professors.isEmpty) {
          return const Center(child: Text('No students found'));
        }
        return RefreshIndicator(
          onRefresh: controller.fetchProfessor,
          child: ListView.builder(
            itemCount: controller.professors.length,
            itemBuilder: (context, index) {
              final student = controller.professors[index];
              return ListTile(
                title: Text(student.name),
                subtitle: Text(student.email),
                trailing: Text(student.collegeId),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStudentDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}