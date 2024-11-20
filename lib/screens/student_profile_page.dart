
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import '../providers/user_provider.dart';


class StudentProfilePage extends StatefulWidget {
  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;

    if (token != null) {
      profileProvider.fetchProfileData(token).then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        print('Error fetching profile: $error');
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      print('Token is null, unable to fetch profile data.');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profile = profileProvider.profile;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.red),
            onPressed: () {
              // Navigate to update profile page or show update dialog
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : profile != null
          ? SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profile.profileImageUrl != null
                      ? NetworkImage(profile.profileImageUrl!)
                      : AssetImage('assets/default_profile.png')
                  as ImageProvider,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    profile.nickname ?? 'N/A',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(color: Colors.grey),
            SizedBox(height: 20),
            ProfileDetailRow(
              icon: FontAwesomeIcons.calendarAlt,
              label: 'Date of Birth',
              value: profile.dateOfBirth != null
                  ? profile.dateOfBirth!
                  .toLocal()
                  .toString()
                  .split(' ')[0]
                  : 'N/A',
            ),
            ProfileDetailRow(
              icon: FontAwesomeIcons.mapMarkerAlt,
              label: 'Location',
              value: profile.location ?? 'N/A',
            ),
            ProfileDetailRow(
              icon: FontAwesomeIcons.school,
              label: 'Year',
              value: profile.year ?? 'N/A',
            ),
            ProfileDetailRow(
              icon: FontAwesomeIcons.graduationCap,
              label: 'Semester',
              value: profile.semester ?? 'N/A',
            ),
            SizedBox(height: 30),
          ],
        ),
      )
          : Center(child: Text('Profile not found')),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          SizedBox(width: 15),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}