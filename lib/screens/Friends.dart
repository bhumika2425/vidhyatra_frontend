import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/FriendsController.dart';

class FriendsScreen extends StatelessWidget {
  final FriendsController controller = Get.put(FriendsController());

  // Reactive text color for the buttons
  Rx<Color> viewFriendsTextColor = Colors.red.obs;  // Initially red
  Rx<Color> viewAllUsersTextColor = Colors.grey.obs; // Initially grey
  @override
  Widget build(BuildContext context) {
    // Set the default view to 'friends' and update the displayed list
    controller.isViewingFriends.value = true;
    controller.updateDisplayedList();  // Fetch and display friends by default

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
                hintText: 'Search by email...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: controller.filterList,
            ),
          ),

          // Buttons for View Friends and View All Users
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // View Friends Button (Text Button)
                Obx(() => TextButton(
                  onPressed: () {
                    controller.isViewingFriends.value = true; // Set to view friends
                    controller.updateDisplayedList(); // Update the list

                    // Change text color to red on press
                    viewFriendsTextColor.value = Colors.red;
                    viewAllUsersTextColor.value = Colors.grey; // Reset the other button
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: viewFriendsTextColor.value, // Reactive text color
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  ),
                  child: const Text(
                    'View Friends',
                    style: TextStyle(fontSize: 16.0),
                  ),
                )),

                // View All Users Button (Text Button)
                Obx(() => TextButton(
                  onPressed: () {
                    controller.isViewingFriends.value = false; // Set to view all users
                    controller.updateDisplayedList(); // Update the list

                    // Change text color to red on press
                    viewAllUsersTextColor.value = Colors.red;
                    viewFriendsTextColor.value = Colors.grey; // Reset the other button
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: viewAllUsersTextColor.value, // Reactive text color
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  ),
                  child: const Text(
                    'View All Users',
                    style: TextStyle(fontSize: 16.0),
                  ),
                )),
              ],
            ),
          ),

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