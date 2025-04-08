// Import statements
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// NotesListScreen - Main screen showing all notes
class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample note data - replace with your model later
    final sampleNotes = [
      {
        'title': 'Database Systems Architecture',
        'content': 'ACID properties in database transactions...',
        'updatedAt': DateTime.now().subtract(const Duration(hours: 2)),
        'courseName': 'Database Systems',
        'color': Colors.blue.shade200,
      },
      {
        'title': 'Flutter Widgets',
        'content': 'StatefulWidget vs StatelessWidget...',
        'updatedAt': DateTime.now().subtract(const Duration(hours: 36)),
        'courseName': 'Mobile App Development',
        'color': Colors.green.shade200,
      },
      {
        'title': 'Midterm Exam Topics',
        'content': 'Topics to study: Algorithm complexity...',
        'updatedAt': DateTime.now().subtract(const Duration(hours: 1)),
        'courseName': 'Algorithms',
        'color': Colors.red.shade200,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Notes',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality will go here
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // Sort functionality will go here
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                hintStyle: GoogleFonts.poppins(),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Course filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildFilterChip(context, 'All Courses', isSelected: true),
                _buildFilterChip(context, 'Database Systems'),
                _buildFilterChip(context, 'Mobile App Development'),
                _buildFilterChip(context, 'Algorithms'),
                _buildFilterChip(context, 'Research Methods'),
              ],
            ),
          ),

          // Notes list
          Expanded(
            child: ListView.builder(
              itemCount: sampleNotes.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                final note = sampleNotes[index];
                return _buildNoteCard(
                  context,
                  title: note['title'] as String,
                  content: note['content'] as String,
                  updatedAt: note['updatedAt'] as DateTime,
                  courseName: note['courseName'] as String,
                  color: note['color'] as Color,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteDetailScreen(
                          noteTitle: note['title'] as String,
                          noteContent: note['content'] as String,
                          noteColor: note['color'] as Color,
                          courseName: note['courseName'] as String,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateEditNoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          // Filter selection logic will go here
        },
        backgroundColor: Colors.grey.shade100,
        selectedColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildNoteCard(
      BuildContext context, {
        required String title,
        required String content,
        required DateTime updatedAt,
        required String courseName,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                content,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(
                      courseName,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: Colors.white.withOpacity(0.7),
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(
                    'Updated ${_getTimeAgo(updatedAt)}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}

// NoteDetailScreen - Screen to view a single note
class NoteDetailScreen extends StatelessWidget {
  final String noteTitle;
  final String noteContent;
  final Color noteColor;
  final String courseName;

  const NoteDetailScreen({
    Key? key,
    required this.noteTitle,
    required this.noteContent,
    required this.noteColor,
    required this.courseName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Note Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: noteColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateEditNoteScreen(
                    isEditing: true,
                    noteTitle: noteTitle,
                    noteContent: noteContent,
                    noteColor: noteColor,
                    courseName: courseName,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Delete functionality will go here
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Delete Note',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  content: Text(
                    'Are you sure you want to delete this note? This action cannot be undone.',
                    style: GoogleFonts.poppins(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Return to list
                      },
                      child: Text(
                        'Delete',
                        style: GoogleFonts.poppins(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: noteColor.withOpacity(0.5),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Title
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                    children: [
                      Expanded(
                        child: Text(
                          noteTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Chip(
                        label: Text(
                          courseName,
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        backgroundColor: noteColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated on ${DateFormat('MMM dd, yyyy • HH:mm').format(DateTime.now())}',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                noteContent,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Share functionality will go here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Sharing note...',
                style: GoogleFonts.poppins(),
              ),
            ),
          );
        },
        child: const Icon(Icons.share),
      ),
    );
  }
}

// CreateEditNoteScreen - Screen to create or edit a note
class CreateEditNoteScreen extends StatefulWidget {
  final bool isEditing;
  final String? noteTitle;
  final String? noteContent;
  final Color? noteColor;
  final String? courseName;

  const CreateEditNoteScreen({
    Key? key,
    this.isEditing = false,
    this.noteTitle,
    this.noteContent,
    this.noteColor,
    this.courseName,
  }) : super(key: key);

  @override
  _CreateEditNoteScreenState createState() => _CreateEditNoteScreenState();
}

class _CreateEditNoteScreenState extends State<CreateEditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Color _selectedColor;
  String _selectedCourse = 'Mobile App Development';

  final List<Color> _colorOptions = [
    Colors.blue.shade200,
    Colors.green.shade200,
    Colors.red.shade200,
    Colors.orange.shade200,
    Colors.purple.shade200,
    Colors.teal.shade200,
    Colors.pink.shade200,
    Colors.amber.shade200,
  ];

  final List<String> _courseOptions = [
    'Mobile App Development',
    'Database Systems',
    'Algorithms',
    'Research Methods',
    'Data Science',
    'Computer Networks',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.noteTitle ?? '');
    _contentController = TextEditingController(text: widget.noteContent ?? '');
    _selectedColor = widget.noteColor ?? _colorOptions[0];
    if (widget.courseName != null) {
      _selectedCourse = widget.courseName!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Note' : 'Create Note',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: _selectedColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Save note logic will go here
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        color: _selectedColor.withOpacity(0.5),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Title field
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Note Title',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter note title',
                      hintStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content field
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Note Content',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contentController,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                    ),
                    maxLines: 12,
                    decoration: InputDecoration(
                      hintText: 'Enter note content',
                      hintStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Course selection
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Course',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCourse,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: GoogleFonts.poppins(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCourse = newValue;
                        });
                      }
                    },
                    items: _courseOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.poppins(),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Color selection
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Note Color',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _colorOptions.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor == color ? Colors.black : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: _selectedColor == color
                              ? const Icon(Icons.check, color: Colors.black)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}