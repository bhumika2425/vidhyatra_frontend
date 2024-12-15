import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/FriendsController.dart';

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
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by name...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: controller.filterList,
            ),
          ),

          // Toggle Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: controller.toggleView,
                  child: Obx(() => Text(
                    controller.isViewingFriends.value ? 'View All Users' : 'View Friends',
                    style: const TextStyle(fontSize: 16.0),
                  )),
                ),
              ],
            ),
          ),

          // Users/Friends List
          // Expanded(
          //   child: Obx(() => ListView.builder(
          //     itemCount: controller.displayedList.length,
          //     itemBuilder: (context, index) {
          //       final user = controller.displayedList[index];
          //       return Padding(
          //         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          //         child: Card(
          //           child: ListTile(
          //             leading: const Icon(Icons.person),
          //             title: Text(user['name']),
          //             subtitle: Text(user['email']),
          //             trailing: Text(user['role']),
          //           ),
          //         ),
          //       );
          //     },
          //   )),
          // ),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.displayedList.length,
              itemBuilder: (context, index) {
                final user = controller.displayedList[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0,),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Adds rounded corners
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12.0), // Adds padding inside the ListTile
                      leading: const Icon(Icons.person),
                      title: Text(
                        '${user['name']} (${user['role']})', // Shows name and role in the format: name(role)
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Make name bold
                        ),
                      ),
                      subtitle: Text(user['email']),
                      trailing: PopupMenuButton<String>(
                        onSelected: (String value) {
                          if (value == 'send_request') {
                            // Logic for sending a friend request
                            print("Send friend request to ${user['name']}");
                          } else if (value == 'block_user') {
                            // Logic for blocking the user
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
                        icon: Icon(Icons.more_vert), // Icon to show the options
                      ),
                    ),
                  ),
                );
              },
            )),
          )

        ],
      ),
    );
  }
}
