import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Accountpage extends StatelessWidget {
  const Accountpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accounts"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.key_off),
            title: Text("Change Password"),
            onTap: (){

            },
          ),
          ListTile(
            leading: Icon(Icons.feed_outlined),
            title: Text("Send Feedback"),
            onTap: (){
              Get.toNamed("/sendFeedback");
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red,),
            title: Text("Delete", style: TextStyle(color: Colors.red),),
            onTap: (){
              Get.toNamed("/sendFeedback");
            },
          ),

          ListTile(
            leading: Icon(Icons.logout, color: Colors.red,),
            title: Text('Logout', style: TextStyle(color: Colors.red),),
            onTap: () async {
              // Show a confirmation dialog
              bool? confirmLogout = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirm Logout"),
                    content: Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Cancel logout
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // Confirm logout
                        },
                        child: Text("Logout"),
                      ),
                    ],
                  );
                },
              );

              // Proceed with logout if user confirmed
              if (confirmLogout == true) {
                await Future.delayed(Duration(seconds: 1)); // Simulate a delay if needed
                Get.offAllNamed('/login');
              }
            },
          )
        ],
      ),
    );
  }
}
