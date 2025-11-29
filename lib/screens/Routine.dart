import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../constants/app_themes.dart';
import '../controllers/RoutineController.dart';

class Routine extends StatelessWidget {
  final RoutineController routineController = Get.find<RoutineController>();

  Routine({super.key});
//key helps Flutter identify and manage widget trees more efficiently
  @override
  Widget build(BuildContext context) {
    final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday','Saturday'];

    return Scaffold(
      backgroundColor: AppThemes.secondaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppThemes.appBarColor,
        title: Text(
          'Weekly Timetable',
          style: GoogleFonts.poppins(
            color: AppThemes.appBarTextColor,
            fontSize: 19,
            // fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppThemes.appBarTextColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (routineController.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppThemes.darkMaroon));
        }
        if (routineController.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 80,
                    color: AppThemes.darkMaroon.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Routine Yet',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppThemes.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    routineController.errorMessage.value,
                    style: GoogleFonts.poppins(
                      color: AppThemes.secondaryTextColor,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppThemes.darkMaroon.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notifications_active_outlined,
                          size: 20,
                          color: AppThemes.darkMaroon,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'You\'ll be notified once it\'s ready',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppThemes.darkMaroon,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (routineController.routineByDay.value == null) {
          return Center(
            child: Text(
              'No routine available',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppThemes.secondaryTextColor,
              ),
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
                labelColor: AppThemes.darkMaroon,
                unselectedLabelColor: AppThemes.mediumGrey,
                indicatorColor: AppThemes.darkMaroon,
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
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: AppThemes.secondaryTextColor,
          ),
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
          color: AppThemes.cardColor,
          elevation: 2,
          child: Container(
            decoration: BoxDecoration(
              color: AppThemes.darkMaroon.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(CupertinoIcons.time, size: 15, color: AppThemes.primaryTextColor),
                      const SizedBox(width: 5),
                      Text(
                        '${DateFormat('hh:mm a').format(startTime)} - ${DateFormat('hh:mm a').format(endTime)}',
                        style: GoogleFonts.poppins(color: AppThemes.primaryTextColor),
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.room_outlined, size: 15, color: AppThemes.primaryTextColor),
                      const SizedBox(width: 5),
                      Text(
                        entry.room,
                        style: GoogleFonts.poppins(color: AppThemes.primaryTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    entry.subject,
                    style: GoogleFonts.poppins(
                      fontSize: 16, 
                      color: AppThemes.primaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'By ${entry.teacher}',
                    style: GoogleFonts.poppins(
                      fontSize: 14, 
                      color: AppThemes.secondaryTextColor,
                    ),
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