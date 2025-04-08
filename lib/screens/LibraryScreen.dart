// library_screen.dart - Main library screen for Vidhyatra app

import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0277BD),
        title: const Text('Library', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: Column(
        children: [


          // Tab bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF0277BD),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF0277BD),
              tabs: const [
                Tab(text: 'Books'),
                Tab(text: 'E-Resources'),
                Tab(text: 'My Account'),
              ],
            ),
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBooksTab(),
                _buildEResourcesTab(),
                _buildMyAccountTab(),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF0277BD),
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // Library tab selected
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Fees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBooksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryCard('Computer Science', Icons.computer),
                _buildCategoryCard('BBA', Icons.calculate),
                _buildCategoryCard('Science Fiction', Icons.engineering),
                _buildCategoryCard('Biography', Icons.auto_stories),
                _buildCategoryCard('Travel', Icons.mode_of_travel),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Recently Added
          _buildSectionHeader('Recently Added'),
          const SizedBox(height: 12),
          _buildBookItem(
            'Artificial Intelligence: A Modern Approach',
            'Stuart Russell, Peter Norvig',
            'Available',
            Colors.green,
          ),
          _buildBookItem(
            'Clean Code: A Handbook of Agile Software Craftsmanship',
            'Robert C. Martin',
            'Checked Out',
            Colors.red,
          ),
          _buildBookItem(
            'Introduction to Algorithms',
            'Thomas H. Cormen, et al.',
            '2 Copies Available',
            Colors.green,
          ),

          const SizedBox(height: 24),

          // Popular Books
          _buildSectionHeader('Popular This Week'),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildPopularBookCard('assets/book1.jpg', 'Design Patterns', 'Erich Gamma, et al.'),
                _buildPopularBookCard('assets/book2.jpg', 'Database Systems', 'Ramez Elmasri'),
                _buildPopularBookCard('assets/book3.jpg', 'Machine Learning', 'Tom Mitchell'),
                _buildPopularBookCard('assets/book4.jpg', 'Web Development', 'Jennifer Robbins'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEResourcesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Digital Resources
          _buildSectionHeader('Digital Libraries'),
          const SizedBox(height: 12),
          _buildResourceItem('IEEE Xplore Digital Library', Icons.library_books,
              'Access to journals, conference proceedings, and standards'),
          _buildResourceItem('ACM Digital Library', Icons.book_online,
              'Computing and information technology resources'),
          _buildResourceItem('JSTOR', Icons.article,
              'Academic journals, books, and primary sources'),

          const SizedBox(height: 24),

          // E-Books Collection
          _buildSectionHeader('E-Books Collection'),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildEbookCard('assets/ebook1.jpg', 'Neural Networks', 'Free Access'),
                _buildEbookCard('assets/ebook2.jpg', 'Data Science Basics', 'Free Access'),
                _buildEbookCard('assets/ebook3.jpg', 'Cloud Computing', 'Subscription Required'),
                _buildEbookCard('assets/ebook4.jpg', 'Mobile App Development', 'Free Access'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Research Papers
          _buildSectionHeader('Research Papers'),
          const SizedBox(height: 12),
          _buildPaperItem(
            'Machine Learning Applications in Healthcare',
            'International Journal of Medical Informatics',
            'PDF',
          ),
          _buildPaperItem(
            'Blockchain Technology: Current Research and Future Applications',
            'IEEE Transactions on Systems',
            'PDF',
          ),
          _buildPaperItem(
            'Software Engineering Methodologies: A Comparative Study',
            'ACM Computing Surveys',
            'HTML',
          ),
        ],
      ),
    );
  }

  Widget _buildMyAccountTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Currently Borrowed
          _buildSectionHeader('Currently Borrowed'),
          const SizedBox(height: 12),
          _buildBorrowedItem(
            'Fundamentals of Database Systems',
            'Due: April 22, 2025',
            0.7,
          ),
          _buildBorrowedItem(
            'Computer Networks: A Systems Approach',
            'Due: April 15, 2025',
            0.3,
          ),

          const SizedBox(height: 24),

          // Reservations
          _buildSectionHeader('Reservations'),
          const SizedBox(height: 12),
          _buildReservationItem(
            'Software Engineering',
            'Ian Sommerville',
            'Ready for pickup',
            Colors.green,
          ),
          _buildReservationItem(
            'Operating System Concepts',
            'Abraham Silberschatz',
            'In queue (3rd in line)',
            Colors.orange,
          ),

          const SizedBox(height: 24),

          // Library Services
          _buildSectionHeader('Library Services'),
          const SizedBox(height: 12),
          _buildServiceCard('Study Room Booking', Icons.meeting_room),
          _buildServiceCard('Research Assistance', Icons.support_agent),
          _buildServiceCard('Inter-Library Loan', Icons.swap_horiz),
          _buildServiceCard('Library Workshop', Icons.event),

          const SizedBox(height: 24),

          // Fines and Payments
          _buildSectionHeader('Fines and Payments'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Outstanding Balance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '\$3.50',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Late return: Algorithms & Data Structures',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0277BD),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Pay Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: const Color(0xFF0277BD)),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See All',
            style: TextStyle(color: Color(0xFF0277BD)),
          ),
        ),
      ],
    );
  }

  Widget _buildBookItem(String title, String author, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.book, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  author,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                      child: status == 'Available' || status.contains('Available')
                          ? const Text('Reserve')
                          : const Text('Join Queue'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularBookCard(String image, String title, String author) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.book, size: 48, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            author,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(String title, IconData icon, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0277BD).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF0277BD)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildEbookCard(String image, String title, String access) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.menu_book, size: 48, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            access,
            style: TextStyle(
              color: access.contains('Free') ? Colors.green : Colors.orange,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPaperItem(String title, String journal, String format) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: format == 'PDF' ? Colors.red.shade100 : Colors.blue.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              format,
              style: TextStyle(
                color: format == 'PDF' ? Colors.red : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  journal,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Color(0xFF0277BD)),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBorrowedItem(String title, String dueDate, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.book, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dueDate,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRounded(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress < 0.3 ? Colors.red : const Color(0xFF0277BD),
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF0277BD),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Renew'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReservationItem(String title, String author, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.book, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  author,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    status == 'Ready for pickup'
                        ? TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('Collect'),
                    )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0277BD)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}

// Helper widget for rounded clipping
class ClipRounded extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;

  const ClipRounded({
    Key? key,
    required this.child,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: child,
    );
  }
}