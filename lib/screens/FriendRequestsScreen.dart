import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/FriendsController.dart';

class FriendRequestsScreen extends StatelessWidget {
  final FriendsController controller = Get.find<FriendsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Requests'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by email...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: controller.filterList,  // Use filterList from FriendsController
            ),
          ),

          // Displaying Friend Requests
          Expanded(
            child: Obx(() {
              if (controller.friendRequests.isEmpty) {
                return Center(child: Text("No friend requests to display"));
              }

              return ListView.builder(
                itemCount: controller.friendRequests.length,
                itemBuilder: (context, index) {
                  final request = controller.friendRequests[index];
                  return _buildPendingRequestCard(request);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Pending request card widget
  Widget _buildPendingRequestCard(Map<String, dynamic> request) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12.0),
          leading: const Icon(Icons.person_add),
          title: Text('Friend Request from User ID: ${request['sender_id']}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status: ${request['status']}'),
              Text('Created At: ${request['created_at']}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.check, color: Colors.green),
                onPressed: () {
                  print("Accepting friend request: ${request['friend_request_id']}");
                  // Add logic to accept the friend request
                },
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  print("Declining friend request: ${request['friend_request_id']}");
                  // Add logic to decline the friend request
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
