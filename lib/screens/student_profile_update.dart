// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
//
// import '../controllers/LoginController.dart';
// import '../models/profile.dart';
//
// class StudentProfileUpdate extends StatefulWidget {
//   const StudentProfileUpdate({super.key});
//
//   @override
//   State<StudentProfileUpdate> createState() => _StudentProfileUpdateState();
// }
//
// class _StudentProfileUpdateState extends State<StudentProfileUpdate> {
//   final _formKey = GlobalKey<FormState>();
//   String? _fullname;
//   String? _location;
//   String? _department;
//   String? _year;
//   String? _semester;
//   XFile? _profileImage;
//
//   final ImagePicker _picker = ImagePicker();
//   final TextEditingController _dateOfBirthController = TextEditingController();
//
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
//     final token = Get.find<LoginController>().token.value;
//
//     if (token != null) {
//       profileProvider.fetchProfileData(token).then((_) {
//         // After fetching profile data, populate the text fields
//         _populateProfileFields(profileProvider.profile);
//         setState(() {
//           _isLoading = false;
//         });
//       }).catchError((error) {
//         print('Error fetching profile: $error');
//         setState(() {
//           _isLoading = false;
//         });
//       });
//     } else {
//       print('Token is null, unable to fetch profile data.');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   // Method to populate the text fields with fetched profile data
//   void _populateProfileFields(Profile? profile) {
//     if (profile != null) {
//       setState(() {
//         _fullname = profile.fullname;
//         _location = profile.location;
//         _department = profile.department;
//         _year = profile.year;
//         _semester = profile.semester;
//         _dateOfBirthController.text = profile.dateOfBirth.toLocal().toString().split(' ')[0]; // Format date
//       });
//     }
//   }
//
//   void _removeImage() {
//     setState(() {
//       _profileImage = null;
//     });
//   }
//
//   @override
//   void dispose() {
//     _dateOfBirthController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _profileImage = pickedFile;
//       });
//     }
//   }
//
//
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _dateOfBirthController.text = "${pickedDate.toLocal()}".split(' ')[0];
//       });
//     }
//   }
//
//   Future<void> _submitForm() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       _formKey.currentState?.save();
//
//       setState(() {
//         _isLoading = true;
//       });
//
//       try {
//         final token = Get.find<LoginController>().token.value;
//
//         // Prepare request body
//         final Map<String, dynamic> body = {
//           'full_name': _fullname,
//           'date_of_birth': _dateOfBirthController.text,
//           'location': _location,
//           'department': _department,
//           'year': _year,
//           'semester': _semester,
//         };
//
//         // Add profile image if it exists
//         if (_profileImage != null) {
//           // Use multipart for image upload
//           var request = http.MultipartRequest(
//             'PUT',
//             Uri.parse(ApiEndPoints.updateStudentProfileImage),
//           );
//
//           request.headers['Authorization'] = 'Bearer $token';
//           request.fields.addAll(body.map((key, value) => MapEntry(key, value.toString())));
//           request.files.add(await http.MultipartFile.fromPath(
//             'profileImage',
//             _profileImage!.path,
//           ));
//
//           final response = await request.send();
//           if (response.statusCode == 200) {
//             // Handle success
//             final responseBody = await response.stream.bytesToString();
//             final data = json.decode(responseBody);
//             Provider.of<ProfileProvider>(context, listen: false)
//                 .setProfile(Profile.fromJson(data['profile']));
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Profile updated successfully')),
//             );
//             Navigator.pop(context);
//           } else {
//             throw Exception('Failed to update profile');
//           }
//         } else {
//           // Standard JSON request if no image
//           final response = await http.put(
//             Uri.parse(ApiEndPoints.studentProfileUpdate),
//             headers: {
//               'Authorization': 'Bearer $token',
//               'Content-Type': 'application/json',
//             },
//             body: json.encode(body),
//           );
//
//           if (response.statusCode == 200) {
//             final data = json.decode(response.body);
//             Provider.of<ProfileProvider>(context, listen: false)
//                 .setProfile(Profile.fromJson(data['profile']));
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Profile updated successfully')),
//             );
//           } else {
//             throw Exception('Failed to update profile');
//           }
//         }
//       } catch (error) {
//         print('Error updating profile: $error');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $error')),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserProvider>(context).user;
//     final profile = Provider.of<ProfileProvider>(context).profile;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF971F20),
//         title: Text(
//           'Update Profile, ${user?.name}',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF971F20),
//               Colors.white,
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             stops: [0.3, 0.7],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Stack(
//                       children: [
//                         GestureDetector(
//                           onTap: _pickImage,
//                           child: CircleAvatar(
//                             radius: 70,
//                             backgroundImage: _profileImage != null
//                                 ? FileImage(File(_profileImage!.path))
//                                 : (profile?.profileImageUrl != null
//                                 ? NetworkImage(profile!.profileImageUrl!)
//                                 : AssetImage('assets/default_profile.png')) as ImageProvider,
//                             child: _profileImage == null && profile?.profileImageUrl == null
//                                 ? Icon(
//                               Icons.camera_alt,
//                               size: 50,
//                               color: Colors.white,
//                             )
//                                 : null,
//                           ),
//                         ),
//                         if (_profileImage != null)
//                           Positioned(
//                             right: -3,
//                             top: -3,
//                             child: IconButton(
//                               icon: Icon(Icons.cancel, color: Colors.red),
//                               onPressed: _removeImage,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Card(
//                     color: Color(0xFFE7E3E3),
//                     elevation: 15.0,
//                     shadowColor: Colors.black.withOpacity(1),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(1.0),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           Text(
//                             "Personal Details",
//                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
//                           ),
//                           SizedBox(height: 30),
//                           _buildTextFormField(
//                             label: 'Full name',
//                             icon: Icons.person,
//                             initialValue: _fullname,
//                             onSaved: (value) => _fullname = value,
//                             validator: (value) => value!.isEmpty ? 'Please enter full name' : null,
//                           ),
//                           SizedBox(height: 15),
//                           GestureDetector(
//                             onTap: () => _selectDate(context),
//                             child: AbsorbPointer(
//                               child: TextFormField(
//                                 controller: _dateOfBirthController,
//                                 decoration: InputDecoration(
//                                   labelText: "Date of Birth",
//                                   prefixIcon: Icon(Icons.calendar_today),
//                                 ),
//                                 validator: (value) => value!.isEmpty ? 'Please select a date' : null,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 15),
//                           _buildTextFormField(
//                             label: 'Location',
//                             icon: Icons.location_city,
//                             initialValue: _location,
//                             onSaved: (value) => _location = value,
//                             validator: (value) => value!.isEmpty ? 'Please enter location' : null,
//                           ),
//                           SizedBox(height: 15),
//                           _buildTextFormField(
//                             label: 'Department',
//                             icon: Icons.work,
//                             initialValue: _department,
//                             onSaved: (value) => _department = value,
//                             validator: (value) => value!.isEmpty ? 'Please enter department' : null,
//                           ),
//                           SizedBox(height: 15),
//                           _buildTextFormField(
//                             label: 'Year',
//                             icon: Icons.calendar_today,
//                             initialValue: _year,
//                             onSaved: (value) => _year = value,
//                             validator: (value) => value!.isEmpty ? 'Please enter year' : null,
//                           ),
//                           SizedBox(height: 15),
//                           _buildTextFormField(
//                             label: 'Semester',
//                             icon: Icons.date_range,
//                             initialValue: _semester,
//                             onSaved: (value) => _semester = value,
//                             validator: (value) => value!.isEmpty ? 'Please enter semester' : null,
//                           ),
//
//                           SizedBox(height: 30),
//                           Container(
//                             width: MediaQuery.of(context).size.width / 2,
//                             child: ElevatedButton(
//                               onPressed: _submitForm,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Color(0xFF971F20),
//                                 padding: EdgeInsets.symmetric(vertical: 16.0),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15.0),
//                                 ),
//                               ),
//                               child: Text(
//                                 'Save Profile',
//                                 style: TextStyle(fontSize: 16, color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   TextFormField _buildTextFormField({
//     required String label,
//     required IconData icon,
//     String? initialValue,
//     required FormFieldSetter<String> onSaved,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       initialValue: initialValue,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//       ),
//       onSaved: onSaved,
//       validator: validator,
//     );
//   }
// }
//
