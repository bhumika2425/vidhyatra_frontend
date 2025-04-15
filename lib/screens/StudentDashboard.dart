import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:vidhyatra_flutter/screens/FeesScreen.dart';
import 'package:vidhyatra_flutter/screens/TeacherListScreen.dart';
import 'package:vidhyatra_flutter/screens/blog_posting_page.dart';
import 'package:vidhyatra_flutter/screens/profile_creation.dart';
import 'package:vidhyatra_flutter/screens/DashboardTabs.dart'; // Import DashboardTabs
import '../controllers/BlogController.dart';
import '../controllers/EventController.dart';
import '../controllers/LoginController.dart';
import '../controllers/ProfileController.dart';
import '../controllers/RoutineController.dart';
import '../controllers/deadline_controller.dart';
import '../models/EventsModel.dart';
import 'EventDetailsPage.dart';
import 'NotesScreen.dart';
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
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load dashboard: $e';
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshDashboard() async {
    setState(() => _isLoading = true);
    await _initializeDashboard();
  }

  final EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String today = DateFormat('EEEE, MMMM d').format(now);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(),
      drawer: _buildDrawer(context),
      body: _isLoading
          ? const Center(
          child: CircularProgressIndicator(color: Color(0xFF186CAC)))
          : _errorMessage != null
          ? Center(
          child: Text(_errorMessage!,
              style: GoogleFonts.poppins(color: Colors.red)))
          : RefreshIndicator(
        onRefresh: _refreshDashboard,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: DashboardTabs(
                      homeTabContent: _buildHomeTab(today),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/new-post'),
        backgroundColor: Color(0xFF186CAC),
        child: Icon(Icons.edit, color: Colors.white),
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _isSearching ? Colors.white : const Color(0xFF186CAC),
      elevation: 0,
      leading: _isSearching
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => setState(() {
          _isSearching = false;
          _searchController.clear();
        }),
      )
          : Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: _isSearching
          ? TextField(
        controller: _searchController,
        decoration: const InputDecoration(
            hintText: 'Search...', border: InputBorder.none),
        autofocus: true,
        onChanged: (value) {},
      )
          : Text(
        "Vidhyatra",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: _isSearching
          ? []
          : [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () => setState(() => _isSearching = true),
        ),
        IconButton(
          icon: const Badge(
            label: Text('3'),
            child: Icon(Icons.notifications, color: Colors.white),
          ),
          onPressed: () => Get.toNamed('/notifications'),
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
            decoration: const BoxDecoration(color: Color(0xFF186CAC)),
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
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text(
                    profileController.profile.value?.department ?? 'Department',
                    style: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          _buildDrawerItem(Icons.dashboard, 'Dashboard'),
          _buildDrawerItem(Icons.book_online, 'Appointment'),
          _buildDrawerItem(Icons.library_books, 'Library'),
          _buildDrawerItem(Icons.note_alt, 'Notes'),
          _buildDrawerItem(Icons.help, 'Help & Support'),
          _buildDrawerItem(Icons.settings, 'Settings'),
          _buildDrawerItem(Icons.logout, 'Logout', color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title,
      {Color color = const Color(0xFF186CAC)}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: GoogleFonts.poppins()),
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
        // _buildAttendanceOverview(),
        // const SizedBox(height: 20),
        _buildLatestAnnouncements(),
      ],
    );
  }

  Widget _buildTodaySchedule() {
    return Obx(() {
      if (routineController.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: Color(0xFF186CAC)));
      }

      final todayRoutine = routineController.getTodayRoutine();

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Timeline",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => Get.to(() => Routine()),
                child: Text(
                  "View Full Schedule",
                  style: GoogleFonts.poppins(color: const Color(0xFF186CAC)),
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
                final startTime = DateFormat('HH:mm:ss').parse(entry.startTime);
                final endTime = DateFormat('HH:mm:ss').parse(entry.endTime);
                final currentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);
                final classStart = DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute);
                final classEnd = DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

                String status;
                Color statusColor;
                if (currentTime.isAfter(classStart) && currentTime.isBefore(classEnd)) {
                  status = 'ONGOING CLASS';
                  statusColor = Colors.green;
                } else if (currentTime.isBefore(classStart)) {
                  status = 'UPCOMING CLASS';
                  statusColor = Colors.orange;
                } else {
                  status = 'COMPLETED CLASS';
                  statusColor = Colors.grey;
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

  Widget _buildTimelineCard(String time, String location, String course, String status, Color statusColor, {required String teacher}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x33186CAC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(CupertinoIcons.time, size: 15, color: Colors.black87),
                  const SizedBox(width: 5),
                  Text(time, style: GoogleFonts.poppins(color: Colors.black87)),
                  const SizedBox(width: 15),
                  const Icon(Icons.room_outlined, size: 15, color: Colors.black87),
                  const SizedBox(width: 5),
                  Text(location, style: GoogleFonts.poppins(color: Colors.black87)),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                course,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 5),
              Text(
                'By $teacher',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Announcements",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed('/calendar'),
              child: Text(
                "View All",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF186CAC),
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
                    child: ListTile(
                      title: Text(
                        event.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF186CAC),
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
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Get.to(EventDetailsPage(event: event));
                      },
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
            if (deadlineController.deadlines.length > 2)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => deadlineController.showAll.toggle(),
                  child: Text(
                    deadlineController.showAll.value
                        ? 'View Less'
                        : 'View All',
                    style: const TextStyle(color: Color(0xFF186CAC)),
                  ),
                ),
              ),
          ],
        ),
        deadlineController.isLoading.value
            ? const Center(
            child: CircularProgressIndicator(color: Color(0xFF186CAC)))
            : deadlineController.deadlines.isEmpty
            ? _buildEmptyDeadlinesState()
            : Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: deadlineController.showAll.value
                  ? deadlineController.deadlines.length
                  : (deadlineController.deadlines.length > 2
                  ? 2
                  : deadlineController.deadlines.length),
              itemBuilder: (context, index) {
                final deadline =
                deadlineController.deadlines[index];
                final timeLeft =
                deadline.deadline.difference(DateTime.now());
                final timeLeftText = timeLeft.inDays > 0
                    ? '${timeLeft.inDays} days left'
                    : timeLeft.inHours > 0
                    ? '${timeLeft.inHours} hours left'
                    : '${timeLeft.inMinutes} mins left';

                Color urgencyColor = Colors.green;
                if (timeLeft.inDays < 1) {
                  urgencyColor = Colors.red;
                } else if (timeLeft.inDays < 3) {
                  urgencyColor = Colors.orange;
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
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
                        style: GoogleFonts.poppins(
                            color: Colors.grey)),
                    trailing: Checkbox(
                      activeColor: const Color(0xFF186CAC),
                      value: deadline.isCompleted,
                      onChanged: (value) {
                        if (value != null) {
                          deadlineController
                              .markDeadlineCompleted(
                              deadline.id, value);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ],
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
          borderRadius: BorderRadius.circular(15), color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
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
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
            Text(displayName,
                style: GoogleFonts.poppins(
                    fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(today,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 10),
            profileController.isNewUser.value
                ? Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF186CAC), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Complete your profile to get personalized content",
                    style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFF186CAC)),
                  ),
                ),
                TextButton(
                  onPressed: () => Get.to(() => ProfileCreationPage()),
                  child: Text("Complete Now",
                      style: GoogleFonts.poppins(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold
                      )
                  ),
                )
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
        'screen': () => TeacherListScreen(),
      },
      {
        'title': 'Fees',
        'icon': Icons.money,
        'screen': () => FeesScreen(),
      },
      {
        'title': 'Notes',
        'icon': Icons.note_alt,
        'screen': () => NotesScreen(),
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
            color: Colors.black87,
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
              onTap: () {
                Get.to(item['screen']());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF186CAC).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'],
                      color: const Color(0xFF186CAC),
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
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF186CAC),
        unselectedItemColor: Colors.grey,
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
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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
              Get.toNamed('/messages');
              break;
            case 3:
              _checkAndNavigateToProfile(context);
              break;
          }
        },
      ),
    );
  }

  Widget _buildEmptyDeadlinesState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 58),
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
            Icons.calendar_today,
            size: 50,
            color: Color(0xFFC0C0C0),
          ),
          SizedBox(height: 10),
          Text(
            "Daily Schedule",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Your daily schedule will appear here",
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

  Widget _buildEmptyAnnouncementsState() {
    return Container(
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
            "No Announcements",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Stay tuned for important announcements",
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
}