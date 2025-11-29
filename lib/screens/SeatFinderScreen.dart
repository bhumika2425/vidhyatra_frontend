import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ExamSeatController.dart';
import '../models/exam.dart';
import '../models/seat_allocation.dart';

class SeatFinderScreen extends StatefulWidget {
  @override
  _SeatFinderScreenState createState() => _SeatFinderScreenState();
}

class _SeatFinderScreenState extends State<SeatFinderScreen> {
  final ExamSeatController controller = Get.find<ExamSeatController>();
  final TextEditingController searchController = TextEditingController();
  
  Exam? selectedExam;
  SeatAllocation? searchResult;
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Find My Seat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo[600],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchInstructions(),
            SizedBox(height: 24),
            _buildExamSelector(),
            SizedBox(height: 20),
            _buildSearchForm(),
            SizedBox(height: 24),
            if (searchResult != null) _buildSearchResult(),
            if (searchResult == null && searchController.text.isNotEmpty && !isSearching)
              _buildNoResultFound(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchInstructions() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.indigo[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.indigo[600],
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'How to Find Your Seat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildInstructionStep('1', 'Select your exam from the dropdown'),
          SizedBox(height: 8),
          _buildInstructionStep('2', 'Enter your roll number or college ID'),
          SizedBox(height: 8),
          _buildInstructionStep('3', 'Tap search to find your allocated seat'),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String step, String instruction) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.indigo[600],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              step,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            instruction,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExamSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Exam',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Exam>(
              value: selectedExam,
              hint: Text(
                'Choose an exam',
                style: TextStyle(color: Colors.grey[600]),
              ),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Colors.indigo[600]),
              items: controller.exams.map((exam) {
                return DropdownMenuItem<Exam>(
                  value: exam,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        exam.moduleName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        '${exam.moduleCode} • ${exam.formattedDate}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (Exam? newValue) {
                setState(() {
                  selectedExam = newValue;
                  searchResult = null;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Roll Number / College ID',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'e.g., 22068966',
              prefixIcon: Icon(Icons.search, color: Colors.indigo[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) {
              setState(() {
                searchResult = null;
              });
            },
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: selectedExam != null && searchController.text.isNotEmpty
                ? _performSearch
                : null,
            icon: isSearching
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : Icon(Icons.search, color: Colors.white),
            label: Text(
              isSearching ? 'Searching...' : 'Find My Seat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedExam != null && searchController.text.isNotEmpty
                  ? Colors.indigo[600]
                  : Colors.grey[400],
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResult() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seat Found!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'Roll Number: ${searchResult!.rollNumber}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildResultDetail(
                        'Classroom',
                        searchResult!.classroomName,
                        Icons.room,
                      ),
                    ),
                    Expanded(
                      child: _buildResultDetail(
                        'Seat Number',
                        searchResult!.seatNumber.toString(),
                        Icons.event_seat,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildResultDetail(
                        'Row',
                        searchResult!.rowNumber.toString(),
                        Icons.table_rows,
                      ),
                    ),
                    Expanded(
                      child: _buildResultDetail(
                        'Position',
                        searchResult!.position.toUpperCase(),
                        Icons.my_location,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.snackbar(
                      'Saved',
                      'Seat information saved to your bookmarks',
                      snackPosition: SnackPosition.TOP,
                    );
                  },
                  icon: Icon(Icons.bookmark_add, color: Colors.indigo[600]),
                  label: Text(
                    'Save',
                    style: TextStyle(color: Colors.indigo[600]),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.indigo[600]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.snackbar(
                      'Shared',
                      'Seat information shared successfully!',
                      snackPosition: SnackPosition.TOP,
                    );
                  },
                  icon: Icon(Icons.share, color: Colors.white),
                  label: Text(
                    'Share',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.indigo[600],
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildNoResultFound() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Colors.red,
          ),
          SizedBox(height: 16),
          Text(
            'No Seat Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'No seat allocation found for roll number "${searchController.text}" in the selected exam. Please check your roll number or contact administration.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                searchController.clear();
                searchResult = null;
              });
            },
            icon: Icon(Icons.refresh, color: Colors.indigo[600]),
            label: Text(
              'Try Again',
              style: TextStyle(color: Colors.indigo[600]),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.indigo[600]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch() async {
    if (selectedExam == null || searchController.text.isEmpty) return;

    setState(() {
      isSearching = true;
      searchResult = null;
    });

    try {
      final result = await controller.searchSeatAllocation(
        selectedExam!.examId,
        searchController.text.trim(),
      );

      setState(() {
        searchResult = result;
      });
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to search seat allocation',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      setState(() {
        isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
