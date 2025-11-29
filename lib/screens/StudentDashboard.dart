import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vidhyatra_flutter/screens/ExamSeatPlanningHomeScreen.dart';
import 'package:vidhyatra_flutter/screens/FeesScreen.dart';
import 'package:vidhyatra_flutter/screens/LostAndFound.dart';
import 'package:vidhyatra_flutter/screens/SettingsScreen.dart';
import 'package:vidhyatra_flutter/screens/BookAppointment.dart';
import 'package:vidhyatra_flutter/screens/feedback_form.dart';
import 'package:vidhyatra_flutter/screens/profile_creation.dart';
import 'package:vidhyatra_flutter/screens/AnnouncementsScreen.dart';
import '../constants/app_themes.dart';
import '../controllers/BlogController.dart';
import '../controllers/EventController.dart';
import '../controllers/LoginController.dart';
import '../controllers/NotificationController.dart';
import '../controllers/ProfileController.dart';
import '../controllers/RoutineController.dart';
import '../controllers/AnnouncementController.dart';
import '../controllers/deadline_controller.dart';
import '../models/EventsModel.dart';
import 'EventDetailsPage.dart';
import 'Routine.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final BlogController blogController = Get.put(BlogController());
  final ProfileController profileController = Get.find<ProfileController>();
  final LoginController loginController = Get.find<LoginController>();
  final DeadlineController deadlineController = Get.put(DeadlineController());
  final RoutineController routineController = Get.put(RoutineController());
  final AnnouncementController announcementController = Get.find<AnnouncementController>();
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
  }

  Future<void> _initializeDashboard() async {
    final token = loginController.token.value;
    try {
      await Future.wait([
        profileController.fetchProfileData(token),
        deadlineController.fetchDeadlines(),
      ]);
      setState(() => _isLoading = false);
      
      // Check for announcements after dashboard loads
      _checkAndShowAnnouncements();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load dashboard: $e';
      });
    }
  }

  Future<void> _checkAndShowAnnouncements() async {
    try {
      // Check if there are new announcements to show
      final hasAnnouncements = await announcementController.checkAndShowAnnouncements();
      
      if (hasAnnouncements && mounted) {
        // Navigate to announcements screen
        Get.to(() => const AnnouncementsScreen());
      }
    } catch (e) {
      print('❌ Error checking announcements: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  final EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String today = DateFormat('EEEE, MMMM d').format(now);

    return Scaffold(
      backgroundColor: AppThemes.secondaryBackgroundColor,
      appBar: _buildAppBar(),
      // drawer: _buildDrawer(context),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppThemes.darkMaroon))
          : _errorMessage != null
              ? Center(
                  child: Text(_errorMessage!,
                      style: GoogleFonts.poppins(color: AppThemes.errorColor)))
              : RefreshIndicator(
                  // onRefresh: _refreshDashboard,
                  onRefresh: () async {
                    try {
                      await Future.wait([
                        profileController.fetchProfileData(loginController.token.value),
                        deadlineController.fetchDeadlines(),
                        eventController.fetchEvents(),
                        routineController.fetchRoutines(),
                      ]);
                    } catch (e) {
                      Get.snackbar('Error', 'Failed to refresh some data');
                    }
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: _buildHomeTab(today),
                    ),
                  ),
                ),
      floatingActionButton: _buildAnnouncementFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _isSearching ? AppThemes.white : AppThemes.appBarColor,
      elevation: 0,
      leading: _isSearching
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppThemes.primaryTextColor),
              onPressed: () => setState(() {
                _isSearching = false;
                _searchController.clear();
              }),
            )
          : /*
          Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: AppThemes.appBarTextColor),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          */ null,
      title: Text(
              "Vidhyatra",
              style: GoogleFonts.poppins(
                color: AppThemes.appBarTextColor,
                fontSize: 19,
              ),
            ),
      actions: _isSearching
          ? []
          : [
            Stack(
              children: [
                IconButton(
                  onPressed: (){
                    Get.toNamed('/notifications');
                  }, 
                  icon: Icon(Icons.notifications_outlined), 
                  color: AppThemes.appBarTextColor, 
                  iconSize: 30,
                ),
                Obx(() {
                  final notificationController = Get.find<NotificationController>();
                  final count = notificationController.unreadCount.value;
                  if (count == 0) return SizedBox.shrink();
                  return Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }),
              ],
            ),
              GestureDetector(
                onTap: () => _checkAndNavigateToProfile(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CircleAvatar(
                    backgroundImage: profileController
                                .profile.value?.profileImageUrl !=
                            null
                        ? NetworkImage(
                            profileController.profile.value!.profileImageUrl!)
                        : const AssetImage('assets/default_profile.png')
                            as ImageProvider,
                    radius: 18,
                  ),
                ),
              ),
            ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppThemes.appBarColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage:
                      profileController.profile.value?.profileImageUrl != null
                          ? NetworkImage(
                              profileController.profile.value!.profileImageUrl!)
                          : const AssetImage('assets/default_profile.png')
                              as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(
                    profileController.profile.value?.fullname ?? 'Student Name',
                    style: GoogleFonts.poppins(
                        color: AppThemes.appBarTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text(
                    profileController.profile.value?.department ?? 'Department',
                    style: GoogleFonts.poppins(
                        color: AppThemes.appBarTextColor.withOpacity(0.7), fontSize: 14)),
              ],
            ),
          ),
          _buildDrawerItem(
            Icons.dashboard,
            'Dashboard',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            Icons.book_online,
            'Appointment',
            onTap: () {
              Navigator.pop(context);
              Get.to(() => BookAppointment());
            },
          ),
          _buildDrawerItem(
            Icons.help,
            'Feedback',
            onTap: () {
              Navigator.pop(context);
              Get.to(() => FeedbackForm());
            },
          ),
          _buildDrawerItem(
            Icons.event_seat,
            'Exam Seat Planning',
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/exam-seat-planning');
            },
          ),
          _buildDrawerItem(
            Icons.settings,
            'Settings',
            onTap: () {
              Navigator.pop(context);
              Get.to(() => SettingsScreen());
            },
          ),
          _buildDrawerItem(
            Icons.logout,
            'Logout',
            color: AppThemes.errorColor,
            onTap: () {
              Navigator.pop(context);
              Get.defaultDialog(
                title: 'Logout',
                content: Text('Are you sure you want to logout?'),
                confirm: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.red, // Yes button color
                      ),
                  onPressed: () {
                    Get.back(); // Close the dialog
                    loginController.logout();
                  },
                  child:
                      Text('Yes', style: TextStyle(color: AppThemes.darkMaroon)),
                ),
                cancel: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes.darkMaroon, // No button color
                  ),
                  onPressed: () {
                    Get.back(); // Just close the dialog
                  },
                  child: Text('No', style: TextStyle(color: AppThemes.white)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title,
      {Color color = AppThemes.darkMaroon, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: GoogleFonts.poppins()),
      onTap: onTap,
    );
  }

  Widget _buildHomeTab(String today) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWelcomeCard(today),
        const SizedBox(height: 20),
        _buildQuickAccessGrid(),
        const SizedBox(height: 20),
        _buildTodaySchedule(),
        const SizedBox(height: 20),
        _buildUpcomingDeadlines(),
        const SizedBox(height: 20),
        _buildLatestAnnouncements(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTodaySchedule() {
    return Obx(() {
      if (routineController.isLoading.value) {
        return const Center(
            child: CircularProgressIndicator(color: AppThemes.darkMaroon));
      }

      final todayRoutine = routineController.getTodayRoutine();
      //
      // // Debug prints
      // print('🔍 _buildTodaySchedule Debug:');
      // print('📅 Current Day: ${DateFormat('EEEE').format(DateTime.now())}');
      // print('📊 Total routines fetched: ${todayRoutine.length}');
      // print('🗂️ All routines by day: ${routineController.routineByDay}');
      // if (todayRoutine.isEmpty) {
      //   print('⚠️ No routines found for today');
      // } else {
      //   print('✅ Today\'s routines:');
      //   for (var i = 0; i < todayRoutine.length; i++) {
      //     print('   ${i + 1}. ${todayRoutine[i].subject} (${todayRoutine[i].startTime} - ${todayRoutine[i].endTime})');
      //   }
      // }

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Timeline",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => Get.to(() => Routine()),
                child: Text(
                  "View Full Schedule",
                  style: GoogleFonts.poppins(color: AppThemes.darkMaroon),
                ),
              ),
            ],
          ),
          todayRoutine.isEmpty
              ? _buildEmptyRoutineState()
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: todayRoutine.map((entry) {
                      final now = DateTime.now();
                      final startTime =
                          DateFormat('HH:mm:ss').parse(entry.startTime);
                      final endTime =
                          DateFormat('HH:mm:ss').parse(entry.endTime);
                      final currentTime = DateTime(
                          now.year, now.month, now.day, now.hour, now.minute);
                      final classStart = DateTime(now.year, now.month, now.day,
                          startTime.hour, startTime.minute);
                      final classEnd = DateTime(now.year, now.month, now.day,
                          endTime.hour, endTime.minute);

                      String status;
                      Color statusColor;
                      if (currentTime.isAfter(classStart) &&
                          currentTime.isBefore(classEnd)) {
                        status = 'ONGOING CLASS';
                        statusColor = AppThemes.successColor;
                      } else if (currentTime.isBefore(classStart)) {
                        status = 'UPCOMING CLASS';
                        statusColor = AppThemes.darkMaroon;
                      } else {
                        status = 'COMPLETED CLASS';
                        statusColor = AppThemes.errorColor;
                      }

                      return _buildTimelineCard(
                        '${DateFormat('hh:mm a').format(startTime)} - ${DateFormat('hh:mm a').format(endTime)}',
                        entry.room,
                        entry.subject,
                        status,
                        statusColor,
                        teacher: entry.teacher,
                      );
                    }).toList(),
                  ),
                ),
        ],
      );
    });
  }

  Widget _buildTimelineCard(String time, String location, String course,
      String status, Color statusColor,
      {required String teacher}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: AppThemes.darkMaroon.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(CupertinoIcons.time,
                      size: 15, color: AppThemes.primaryTextColor),
                  const SizedBox(width: 5),
                  Text(time, style: GoogleFonts.poppins(color: AppThemes.primaryTextColor)),
                  const SizedBox(width: 15),
                  const Icon(Icons.room_outlined,
                      size: 15, color: AppThemes.primaryTextColor),
                  const SizedBox(width: 5),
                  Text(location,
                      style: GoogleFonts.poppins(color: AppThemes.primaryTextColor)),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                course,
                style: GoogleFonts.poppins(fontSize: 16, color: AppThemes.primaryTextColor),
              ),
              const SizedBox(height: 5),
              Text(
                'By $teacher',
                style: GoogleFonts.poppins(fontSize: 14, color: AppThemes.secondaryTextColor),
              ),
              const SizedBox(height: 5),
              Text(
                status,
                style: GoogleFonts.poppins(color: statusColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLatestAnnouncements() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Upcoming Events",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppThemes.primaryTextColor,
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed('/calendar'),
              child: Text(
                "View All",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppThemes.darkMaroon,
                ),
              ),
            ),
          ],
        ),
        Obx(() {
          if (eventController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List<Event> upcomingEvents = eventController.events.where((event) {
              DateTime eventDate = DateTime.parse(event.eventDate);
              return eventDate.isAfter(DateTime.now());
            }).toList();

            if (upcomingEvents.isEmpty) {
              return _buildEmptyAnnouncementsState();
            } else {
              int eventCount =
                  upcomingEvents.length > 2 ? 2 : upcomingEvents.length;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: eventCount,
                itemBuilder: (context, index) {
                  Event event = upcomingEvents[index];
                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ListTile(
                        title: Text(
                          event.title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppThemes.darkMaroon,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.description,
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                            Text(
                              'Date: ${event.eventDate}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppThemes.darkMaroon,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () =>
                            Get.to(() => EventDetailsPage(event: event)),
                      ),
                    ),
                  );
                },
              );
            }
          }
        }),
      ],
    );
  }

  Widget _buildUpcomingDeadlines() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text("Upcoming Deadlines",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                if (deadlineController.deadlines
                        .where((deadline) =>
                            deadline.deadline.isAfter(DateTime.now()) ||
                            deadline.deadline.isAtSameMomentAs(DateTime.now()))
                        .length >
                    2)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => deadlineController.showAll.toggle(),
                      child: Text(
                        deadlineController.showAll.value
                            ? 'View Less'
                            : 'View All',
                        style: const TextStyle(color: AppThemes.darkMaroon),
                      ),
                    ),
                  ),
              ],
            ),
            deadlineController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: AppThemes.darkMaroon))
                : deadlineController.deadlines
                        .where((deadline) =>
                            deadline.deadline.isAfter(DateTime.now()) ||
                            deadline.deadline.isAtSameMomentAs(DateTime.now()))
                        .isEmpty
                    ? _buildEmptyDeadlinesState()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: deadlineController.showAll.value
                            ? deadlineController.deadlines
                                .where((deadline) =>
                                    deadline.deadline.isAfter(DateTime.now()) ||
                                    deadline.deadline
                                        .isAtSameMomentAs(DateTime.now()))
                                .length
                            : (deadlineController.deadlines
                                        .where((deadline) =>
                                            deadline.deadline
                                                .isAfter(DateTime.now()) ||
                                            deadline.deadline.isAtSameMomentAs(
                                                DateTime.now()))
                                        .length >
                                    2
                                ? 2
                                : deadlineController.deadlines
                                    .where((deadline) =>
                                        deadline.deadline.isAfter(DateTime.now()) ||
                                        deadline.deadline
                                            .isAtSameMomentAs(DateTime.now()))
                                    .length),
                        itemBuilder: (context, index) {
                          final filteredDeadlines = deadlineController.deadlines
                              .where((deadline) =>
                                  deadline.deadline.isAfter(DateTime.now()) ||
                                  deadline.deadline
                                      .isAtSameMomentAs(DateTime.now()))
                              .toList();
                          final deadline = filteredDeadlines[index];
                          final timeLeft =
                              deadline.deadline.difference(DateTime.now());
                          final timeLeftText = timeLeft.inDays > 0
                              ? '${timeLeft.inDays} days left'
                              : timeLeft.inHours > 0
                                  ? '${timeLeft.inHours} hours left'
                                  : '${timeLeft.inMinutes} mins left';

                          Color urgencyColor = AppThemes.successColor;
                          if (timeLeft.inDays < 1) {
                            urgencyColor = AppThemes.errorColor;
                          } else if (timeLeft.inDays < 3) {
                            urgencyColor = AppThemes.darkMaroon;
                          }

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            color: Colors.white,
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: urgencyColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.assignment_outlined,
                                    color: urgencyColor),
                              ),
                              title: Text(deadline.title,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  '${deadline.course} • $timeLeftText',
                                  style:
                                      GoogleFonts.poppins(color: Colors.grey)),
                              trailing: Checkbox(
                                activeColor: const Color(0xFF186CAC),
                                value: deadline.isCompleted,
                                onChanged: (value) {
                                  if (value != null) {
                                    deadlineController.markDeadlineCompleted(
                                        deadline.id, value);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ));
  }

  Widget _buildWelcomeCard(String today) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

    final String displayName = profileController.isNewUser.value
        ? 'Student'
        : (profileController.profile.value?.fullname ?? 'Student');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppThemes.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppThemes.cardShadowColor,
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(greeting,
                style: GoogleFonts.poppins(fontSize: 16, color: AppThemes.secondaryTextColor)),
            Text(displayName,
                style: GoogleFonts.poppins(
                    fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(today,
                style: GoogleFonts.poppins(fontSize: 14, color: AppThemes.secondaryTextColor)),
            const SizedBox(height: 10),
            profileController.isNewUser.value
                ? Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Color(0xFF186CAC), size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Complete your profile to get personalized content",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Color(0xFF186CAC)),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => ProfileCreationPage()),
                        child: Text(
                          "Complete Now",
                          style: GoogleFonts.poppins(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                : Text("Welcome back! Here's your day at a glance.",
                    style: GoogleFonts.poppins(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessGrid() {
    final List<Map<String, dynamic>> quickAccessItems = [
      {
        'title': 'Timetable',
        'icon': Icons.schedule,
        'screen': () => Routine(),
      },
      {
        'title': 'Appointment',
        'icon': Icons.assignment,
        'screen': () => BookAppointment(),
      },
      {
        'title': 'Fees',
        'icon': Icons.money,
        'screen': () => FeesScreen(),
      },
      {
        'title': 'Lost & Found',
        'icon': Icons.find_in_page,
        'screen': () => LostAndFoundView(),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Access",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppThemes.primaryTextColor,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: quickAccessItems.length,
          itemBuilder: (context, index) {
            final item = quickAccessItems[index];
            return InkWell(
              onTap: () => Get.to(item['screen']()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:  AppThemes.darkMaroon.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'],
                      color: AppThemes.darkMaroon,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item['title'],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _checkAndNavigateToProfile(BuildContext context) {
    if (profileController.profile.value == null) {
      Get.to(() => ProfileCreationPage());
    } else {
      Get.toNamed('/profile');
    }
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: AppThemes.white,
        selectedItemColor: AppThemes.darkMaroon,
        unselectedItemColor: AppThemes.mediumGrey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_seat_outlined),
            label: 'Exam Seat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Get.toNamed('/calendar');
              break;
            case 2:
              Get.to(() => FeedbackForm());
              break;
            case 3:
              Get.toNamed('exam-seat-planning');
              break;
            case 4:
              Get.toNamed('/settings');
              break;
          }
        },
      ),
    );
  }

  Widget _buildEmptyDeadlinesState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 50,
            color: Color(0xFFC0C0C0),
          ),
          SizedBox(height: 10),
          Text(
            "Assignment Deadlines",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Your upcoming assignment deadlines will appear here",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyRoutineState() {
    final today = DateTime.now();
    final isSaturday = today.weekday == DateTime.saturday;
    
    String title;
    String message;
    IconData icon;
    
    if (isSaturday) {
      title = "It's Saturday! 🎉";
      message = "No classes today. Relax, recharge, and enjoy your weekend!";
      icon = Icons.celebration_outlined;
    } else {
      title = "Free Day! ☀️";
      message = "No classes scheduled for today. Make the most of your time!";
      icon = Icons.wb_sunny_outlined;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 78),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 50,
            color: AppThemes.darkMaroon,
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppThemes.darkMaroon,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAnnouncementsState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 45),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(
            Icons.campaign_outlined,
            size: 50,
            color: Color(0xFFC0C0C0),
          ),
          SizedBox(height: 10),
          Text(
            "No events",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Stay tuned for important events",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementFAB() {
    return Obx(() {
      final hasActiveAnnouncements = announcementController.announcements.isNotEmpty;
      final fabColor = hasActiveAnnouncements ? AppThemes.darkMaroon : AppThemes.grey;
      final iconColor = hasActiveAnnouncements ? Colors.white : Colors.grey[300]!;
      final shadowOpacity = hasActiveAnnouncements ? 0.4 : 0.2;

      return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(milliseconds: 800),
        curve: Curves.elasticOut,
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: fabColor.withOpacity(shadowOpacity),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: hasActiveAnnouncements
                    ? () {
                        Get.to(
                          () => AnnouncementsScreen(),
                          transition: Transition.rightToLeftWithFade,
                          duration: Duration(milliseconds: 300),
                        );
                      }
                    : null,
                backgroundColor: fabColor,
                elevation: 6,
                disabledElevation: 2,
                child: hasActiveAnnouncements
                    ? TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: Duration(milliseconds: 1500),
                        curve: Curves.easeInOut,
                        builder: (context, double pulseValue, child) {
                          return Transform.scale(
                            scale: 1 + (pulseValue * 0.2),
                            child: Icon(
                              Icons.campaign_rounded,
                              color: iconColor,
                              size: 28,
                            ),
                          );
                        },
                        onEnd: () {
                          // Restart animation for pulsing effect
                          Future.delayed(Duration(milliseconds: 100), () {
                            if (mounted) {
                              setState(() {});
                            }
                          });
                        },
                      )
                    : Icon(
                        Icons.campaign_rounded,
                        color: iconColor,
                        size: 28,
                      ),
                heroTag: 'announcementFAB',
              ),
            ),
          );
        },
      );
    });
  }
}
