// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/FriendsController.dart';
// import 'FriendRequestsScreen.dart';  // Import the FriendRequestsScreen
//
// class FriendsScreen extends StatelessWidget {
//   final FriendsController controller = Get.put(FriendsController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Friends'),
//       ),
//       body: Column(
//         children: [
//           _buildSearchBar(),
//           _buildFilterButtons(),
//           Expanded(
//             child: Obx(() {
//               return ListView.builder(
//                 itemCount: controller.displayedList.length,
//                 itemBuilder: (context, index) {
//                   final item = controller.displayedList[index];
//                   return controller.selectedButton.value == 'pending_requests'
//                       ? _buildPendingRequestCard(item)  // Friend Request Card
//                       : _buildUserCard(item);          // User Card
//                 },
//               );
//             }),
//           ),
//           // Add a button to navigate to the FriendRequestsScreen
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 Get.to(() => FriendRequestsScreen());  // Navigate to the FriendRequestsScreen
//               },
//               child: Text("View Friend Requests"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Search bar widget
//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         decoration: InputDecoration(
//           prefixIcon: const Icon(Icons.search),
//           hintText: 'Search by email...',
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//         ),
//         onChanged: controller.filterList,
//       ),
//     );
//   }
//
//   // Filter buttons widget
//   Widget _buildFilterButtons() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildFilterButton('Friends', 'friends'),
//           _buildFilterButton('Pending Requests', 'pending_requests'),
//           _buildFilterButton('All Users', 'all_users'),
//         ],
//       ),
//     );
//   }
//
//   // Individual filter button widget
//   Widget _buildFilterButton(String label, String filter) {
//     return Obx(
//           () => TextButton(
//         onPressed: () {
//           controller.selectedButton.value = filter;
//           controller.updateDisplayedList();  // Update the list based on filter selection
//         },
//         style: ButtonStyle(
//           foregroundColor: MaterialStateProperty.all(
//             controller.selectedButton.value == filter
//                 ? Color(0xFF971F20)
//                 : Colors.grey,
//           ),
//         ),
//         child: Text(label, style: TextStyle(fontSize: 16.0)),
//       ),
//     );
//   }
//
//   // User card widget
//   Widget _buildUserCard(Map<String, dynamic> user) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: ListTile(
//           contentPadding: const EdgeInsets.all(12.0),
//           leading: const Icon(Icons.person),
//           title: Text('${user['name']} (${user['role']})',
//               style: TextStyle(fontWeight: FontWeight.bold)),
//           subtitle: Text(user['email']),
//           trailing: PopupMenuButton<String>(
//             onSelected: (String value) {
//               if (value == 'send_request') {
//                 controller.sendFriendRequest(1, user['user_id']);
//               } else if (value == 'block_user') {
//                 print("Block user ${user['name']}");
//               }
//             },
//             itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//               const PopupMenuItem<String>(
//                 value: 'send_request',
//                 child: Text('Send Friend Request'),
//               ),
//               const PopupMenuItem<String>(
//                 value: 'block_user',
//                 child: Text('Block this User'),
//               ),
//             ],
//             icon: Icon(Icons.more_vert),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Pending friend request card widget
//   Widget _buildPendingRequestCard(Map<String, dynamic> request) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: ListTile(
//           contentPadding: const EdgeInsets.all(12.0),
//           leading: const Icon(Icons.person_add),
//           title: Text('Friend Request from User ID: ${request['sender_id']}'),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Status: ${request['status']}'),
//               Text('Created At: ${request['created_at']}'),
//             ],
//           ),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.check, color: Colors.green),
//                 onPressed: () {
//                   print("Accepting friend request: ${request['friend_request_id']}");
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.close, color: Colors.red),
//                 onPressed: () {
//                   print("Declining friend request: ${request['friend_request_id']}");
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/FriendsController.dart';
import 'FriendRequestsScreen.dart'; // Import the FriendRequestsScreen

class FriendsScreen extends StatelessWidget {
  final FriendsController controller = Get.put(FriendsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterButtons(),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.displayedList.length,
                itemBuilder: (context, index) {
                  final item = controller.displayedList[index];
                  return controller.selectedButton.value == 'pending_requests'
                      ? _buildPendingRequestCard(item) // Friend Request Card
                      : _buildUserCard(item); // User Card
                },
              );
            }),
          ),
          // Add a button to navigate to the FriendRequestsScreen
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Get.to(() =>
          //           FriendRequestsScreen()); // Navigate to the FriendRequestsScreen
          //     },
          //     child: Text("View Friend Requests"),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Search bar widget
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search by email...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onChanged: controller.filterList,
      ),
    );
  }

  // Filter buttons widget
  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFilterButton('Friends', 'friends'),
          _buildFilterButton('Pending Requests', 'pending_requests'),
          _buildFilterButton('All Users', 'all_users'),
        ],
      ),
    );
  }

  // Individual filter button widget
  Widget _buildFilterButton(String label, String filter) {
    return Obx(
      () => TextButton(
        onPressed: () {
          controller.selectedButton.value = filter;
          controller
              .updateDisplayedList(); // Update the list based on filter selection
        },
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(
            controller.selectedButton.value == filter
                ? Color(0xFF971F20)
                : Colors.grey,
          ),
        ),
        child: Text(label, style: TextStyle(fontSize: 16.0)),
      ),
    );
  }

  // User card widget
  Widget _buildUserCard(Map<String, dynamic> user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12.0),
          leading: const Icon(Icons.person),
          title: Text('${user['name']} (${user['role']})',
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(user['email']),
          trailing: PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'send_request') {
                controller.sendFriendRequest(1, user['user_id']);
              } else if (value == 'block_user') {
                print("Block user ${user['name']}");
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'send_request',
                child: Text('Send Friend Request'),
              ),
              const PopupMenuItem<String>(
                value: 'block_user',
                child: Text('Block this User'),
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ),
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
          title: Text('${request['sender_name']} (${request['sender_role']})', style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${request['sender_email']}'),
              Text('Sent At: ${request['created_at']}'),
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
