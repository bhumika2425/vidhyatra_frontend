import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:vidhyatra_flutter/screens/FeesScreen.dart';
import 'package:vidhyatra_flutter/screens/LibraryScreen.dart';
import 'package:vidhyatra_flutter/screens/TeacherListScreen.dart';
import 'package:vidhyatra_flutter/screens/profile_creation.dart';

import '../controllers/EventController.dart';
import '../controllers/LoginController.dart';
import '../controllers/ProfileController.dart';
import '../controllers/blogController.dart';
import '../controllers/deadline_controller.dart';
import '../models/EventsModel.dart';
import '../models/blogModel.dart';
import 'EventDetailsPage.dart';
import 'NotesScreen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  final BlogController blogController = Get.put(BlogController());
  final ProfileController profileController = Get.find<ProfileController>();
  final LoginController loginController = Get.find<LoginController>();
  final DeadlineController deadlineController = Get.put(DeadlineController());
  late TabController _tabController;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;

  // Sample data
  final Map<String, double> attendanceData = {
    'CS1234': 87.5,
    'CS2345': 92.0,
    'CS3456': 78.0,
  };


  final List<Map<String, dynamic>> todayClasses = [
    {
      'name': 'Artificial Intelligence',
      'time': '10:00 AM - 11:30 AM',
      'room': 'Room Rara',
      'professor': 'Prof. Sarah Johnson'
    },
    {
      'name': 'Data Structures',
      'time': '1:00 PM - 2:30 PM',
      'room': 'Room Everest',
      'professor': 'Prof. Michael Chen'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this); // 2 tabs: Home and Social
    _initializeDashboard();
  }

  Future<void> _initializeDashboard() async {
    final token = loginController.token.value;
    try {
      await Future.wait([
        profileController.fetchProfileData(token),
        blogController.fetchBlogs(),
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
    _tabController.dispose();
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
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildHomeTab(today), // Home tab with dashboard content
                      _buildSocialTab(), // Social tab with student blogs
                    ],
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
              backgroundImage:
              profileController.profile.value?.profileImageUrl != null
                  ? NetworkImage(
                  profileController.profile.value!.profileImageUrl!)
                  : const AssetImage('assets/default_profile.png')
              as ImageProvider,
              radius: 18,
            ),
          ),
        ),
      ],
      bottom: _isSearching
          ? null
          : PreferredSize(
        preferredSize: const Size.fromHeight(48.0), // Default TabBar height
        child: Container(
          color: Colors.grey[200], // TabBar background color
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.deepOrange,
            labelColor: Colors.deepOrange,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(
                child: Text(
                  'Home',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Social',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
      // onTap: onTap,
    );
  }

  Widget _buildHomeTab(String today) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
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
          _buildAttendanceOverview(),
          const SizedBox(height: 20),
          _buildLatestAnnouncements(),
        ],
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
                color: Colors.black87, // Optional: Consistent dark color
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed('/calender'),
              child: Text(
                "View All",
                style: GoogleFonts.poppins(
                  fontSize: 14, // Optional: Explicit size for consistency
                  color: const Color(0xFF186CAC),
                ),
              ),
            ),
          ],
        ),
        Obx(() {
          if (eventController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Center the loading spinner
          } else if (eventController.errorMessage.value.isNotEmpty) {
            return Text(
              eventController.errorMessage.value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.deepOrange,
              ),
            );
          } else {
            List<Event> upcomingEvents = eventController.events.where((event) {
              DateTime eventDate = DateTime.parse(event.eventDate);
              return eventDate.isAfter(DateTime.now());
            }).toList();

            if (upcomingEvents.isEmpty) {
              return Text(
                'No upcoming events.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.deepOrange, // Optional: Default text color
                ),
              );
            } else {
              int eventCount = upcomingEvents.length > 2 ? 2 : upcomingEvents.length;
              return ListView.builder(
                shrinkWrap: true, // Ensures the ListView takes only the space it needs
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling inside the ListView
                itemCount: eventCount,
                itemBuilder: (context, index) {
                  Event event = upcomingEvents[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        event.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange, // Event name in deep orange
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.description,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              // No color specified, defaults to black/grey from theme
                            ),
                          ),
                          Text(
                            'Date: ${event.eventDate}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF186CAC), // Event date in theme color
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Uncommented as per your code; assumes EventDetailsPage exists
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
              )
            // TextButton(
            //   onPressed: () => Get.toNamed('/assignments'),
            //   child: Text("View All",
            //       style: GoogleFonts.poppins(color: const Color(0xFF186CAC))),
            // ),
          ],
        ),
        deadlineController.isLoading.value
            ? const Center(
            child: CircularProgressIndicator(color: Color(0xFF186CAC)))
            : deadlineController.deadlines.isEmpty
            ? const Center(
            child: Text('No deadlines available',
                style: TextStyle(color: Colors.grey)))
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
                final deadline = deadlineController.deadlines[index];
                final timeLeft = deadline.deadline.difference(DateTime.now());
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

            // SEE MORE / SEE LESS BUTTON

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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white
      ),
      // elevation: 3,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(greeting,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
            Text(profileController.profile.value?.fullname ?? 'Student',
                style: GoogleFonts.poppins(
                    fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(today,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 10),
            Text("Welcome back! Here's your day at a glance.",
                style: GoogleFonts.poppins(fontSize: 14)),
          ],
        ),
      ),    );
  }

  Widget _buildQuickAccessGrid() {
    final List<Map<String, dynamic>> quickAccessItems = [
      {
        'title': 'Timetable',
        'icon': Icons.schedule,
        'screen': () => NotesScreen(), // Placeholder screen
      },
      {
        'title': 'Appointment',
        'icon': Icons.assignment,
        'screen': () => TeacherListScreen(), // Placeholder screen
      },
      {
        'title': 'Fees',
        'icon': Icons.money,
        'screen': () => FeesScreen(), // Placeholder screen
      },
      {
        'title': 'Notes',
        'icon': Icons.note_alt,
        'screen': () => NotesScreen(), // From notes.dart
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
                Get.to(item['screen']()); // Navigate to the respective screen
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
                    item['title'], // Displays "Timetable", "Appointment", etc.
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

  Widget _buildTodaySchedule() {
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
              onPressed: () => Get.toNamed('/classSchedule'),
              child: Text("View Full Schedule",
                  style: GoogleFonts.poppins(color: const Color(0xFF186CAC))),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTimelineCard(
                  "04-4:30PM",
                  "Room Rara",
                  "CS1234 - Artificial Intelligence",
                  "ONGOING CLASS",
                  Colors.green),
              _buildTimelineCard("04:40-5:00PM", "Room Everest",
                  "CS2345 - Data Science", "UPCOMING CLASS", Colors.orange),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineCard(String time, String location, String course,
      String status, Color statusColor) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0x33186CAC), // Light transparent blue
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(CupertinoIcons.time, size: 15, color: Colors.black87),
                  SizedBox(width: 5),
                  Text(time, style: GoogleFonts.poppins(color: Colors.black87)),
                  SizedBox(width: 15),
                  Icon(Icons.room_outlined, size: 15, color: Colors.black87),
                  SizedBox(width: 5),
                  Text(location, style: GoogleFonts.poppins(color: Colors.black87)),
                ],
              ),
              SizedBox(height: 5),
              Text(course,
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black)),
              SizedBox(height: 5),
              Text(status, style: GoogleFonts.poppins(color: statusColor)),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildAttendanceOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Attendance Overview",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => Get.toNamed('/attendance'),
              child: Text("Detailed View",
                  style: GoogleFonts.poppins(color: const Color(0xFF186CAC))),
            ),
          ],
        ),
        Container(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: attendanceData.entries.length,
            itemBuilder: (context, index) {
              final entry = attendanceData.entries.elementAt(index);
              final percentage = entry.value;

              // Determine status color
              Color statusColor = Colors.green;
              if (percentage < 75)
                statusColor = Colors.red;
              else if (percentage < 85) statusColor = Colors.orange;

              return Container(
                width: 140,
                margin: EdgeInsets.only(right: 12),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularPercentIndicator(
                          radius: 30.0,
                          lineWidth: 5.0,
                          percent: percentage / 100,
                          center: Text("${percentage.toInt()}%",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold)),
                          progressColor: statusColor,
                          backgroundColor: Colors.grey.shade200,
                        ),
                        SizedBox(height: 10),
                        Text(entry.key,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 14),
                            textAlign: TextAlign.center),
                        Text(
                          percentage >= 75 ? "Good Standing" : "Warning",
                          style: GoogleFonts.poppins(
                              color: statusColor, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }



  Widget _buildSocialTab() {
    return Obx(() {
      if (blogController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final blogs = blogController.blogs.value;

      if (blogs == null || blogs.isEmpty) {
        return Center(
          child: Text("No blogs available", style: GoogleFonts.poppins()),
        );
      }

      final reversedBlogs = blogs.reversed.toList();

      return SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: reversedBlogs.length,
          itemBuilder: (context, index) {
            final blog = reversedBlogs[index];
            return _buildBlogCard(blog);
          },
        ),
      );
    });
  }

  Widget _buildBlogCard(Blog blog) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: blog.profileImage.isNotEmpty
                      ? NetworkImage(blog.profileImage)
                      : AssetImage('assets/default_profile.png')
                          as ImageProvider,
                ),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(blog.fullName,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 16.0)),
                    Text(timeago.format(blog.createdAt),
                        style: GoogleFonts.poppins(
                            color: Colors.grey, fontSize: 12.0)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(blog.blogDescription,
                style: GoogleFonts.poppins(fontSize: 15)),
            SizedBox(height: 8.0),
            if (blog.imageUrls.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: blog.imageUrls.take(2).map((imageUrl) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.black,
                                  insetPadding: EdgeInsets.zero,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Hero(
                                          tag: imageUrl,
                                          child: Image.network(imageUrl,
                                              fit: BoxFit.contain),
                                        ),
                                      ),
                                      Positioned(
                                        top: 20,
                                        right: 20,
                                        child: IconButton(
                                          icon: Icon(Icons.close,
                                              color: Colors.white, size: 30),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Hero(
                              tag: imageUrl,
                              child: Image.network(imageUrl,
                                  height: 150, width: 150, fit: BoxFit.cover),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (blog.imageUrls.length > 2)
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("All Images",
                                        style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 8.0,
                                          mainAxisSpacing: 8.0,
                                        ),
                                        itemCount: blog.imageUrls.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    backgroundColor:
                                                        Colors.black,
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    child: Stack(
                                                      children: [
                                                        Center(
                                                          child: Hero(
                                                            tag: blog.imageUrls[
                                                                index],
                                                            child: Image.network(
                                                                blog.imageUrls[
                                                                    index],
                                                                fit: BoxFit
                                                                    .contain),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 20,
                                                          right: 20,
                                                          child: IconButton(
                                                            icon: Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
                                                                size: 30),
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Hero(
                                                tag: blog.imageUrls[index],
                                                child: Image.network(
                                                    blog.imageUrls[index],
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text("+${blog.imageUrls.length - 2} more images",
                          style: GoogleFonts.poppins()),
                    ),
                ],
              ),
            SizedBox(height: 8.0),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () => print("like clicked"),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.thumb_up_off_alt_outlined,
                              color: Colors.grey[600], size: 25),
                          SizedBox(width: 5),
                          Text(blog.likes.toString(),
                              style:
                                  GoogleFonts.poppins(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => print("Comment clicked"),
                      child: Icon(Icons.comment,
                          color: Colors.grey[600], size: 24),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.local_library),
          //   label: 'Library',
          // ),
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
              // Already on home
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
}
