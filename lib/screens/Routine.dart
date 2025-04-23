import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/RoutineController.dart';

class Routine extends StatelessWidget {
  final RoutineController routineController = Get.find<RoutineController>();

  Routine({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday','Saturday'];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF186CAC),
        title: Text(
          'Weekly Timetable',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 19,
            // fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (routineController.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF186CAC)));
        }
        if (routineController.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  routineController.errorMessage.value,
                  style: GoogleFonts.poppins(
                    color: Colors.deepOrange,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

              ],
            ),
          );
        }
        if (routineController.routineByDay.value == null) {
          return Center(
            child: Text(
              'No routine available',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          );
        }

        return DefaultTabController(
          length: days.length,
          initialIndex: _getInitialTabIndex(),
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                labelColor: const Color(0xFF186CAC),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF186CAC),
                tabs: days.map((day) => Tab(text: day)).toList(),
                labelStyle: GoogleFonts.poppins(fontSize: 14),
              ),
              Expanded(
                child: TabBarView(
                  children: days.map((day) => _buildDaySchedule(day)).toList(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  int _getInitialTabIndex() {
    final today = DateTime.now().weekday;
    return today == 7 ? 0 : today;
  }

  Widget _buildDaySchedule(String day) {
    final entries = routineController.routineByDay.value!.routinesByDay[day] ?? [];

    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No classes scheduled for $day',
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final startTime = DateFormat('HH:mm:ss').parse(entry.startTime);
        final endTime = DateFormat('HH:mm:ss').parse(entry.endTime);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0x33186CAC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(CupertinoIcons.time, size: 15, color: Colors.black87),
                      const SizedBox(width: 5),
                      Text(
                        '${DateFormat('hh:mm a').format(startTime)} - ${DateFormat('hh:mm a').format(endTime)}',
                        style: GoogleFonts.poppins(color: Colors.black87),
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.room_outlined, size: 15, color: Colors.black87),
                      const SizedBox(width: 5),
                      Text(
                        entry.room,
                        style: GoogleFonts.poppins(color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    entry.subject,
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'By ${entry.teacher}',
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}