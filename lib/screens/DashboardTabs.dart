// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:vidhyatra_flutter/screens/SocailViewTab.dart';
//
// class DashboardTabs extends StatelessWidget {
//   final Widget homeTabContent;
//
//   const DashboardTabs({
//     Key? key,
//     required this.homeTabContent,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: TabBar(
//               labelStyle: GoogleFonts.poppins(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//               ),
//               unselectedLabelStyle: GoogleFonts.poppins(fontSize: 14),
//               labelColor: Color(0xFF186CAC),
//               unselectedLabelColor: Colors.grey[700],
//               indicatorColor: Colors.deepOrange,
//               indicatorWeight: 3,
//               tabs: [
//                 Tab(text: 'Home'),
//                 Tab(text: 'Social'),
//               ],
//             ),
//           ),
//           SizedBox(height: 10),
//           Expanded(
//             child: TabBarView(
//               children: [
//                 SingleChildScrollView(
//                   child: homeTabContent,
//                 ),
//                 SocialTabView(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidhyatra_flutter/screens/SocailViewTab.dart';

class DashboardTabs extends StatelessWidget {
  final Widget homeTabContent;

  const DashboardTabs({
    Key? key,
    required this.homeTabContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Use min to avoid taking infinite height
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(fontSize: 14),
              labelColor: Color(0xFF186CAC),
              unselectedLabelColor: Colors.grey[700],
              indicatorColor: Colors.deepOrange,
              indicatorWeight: 3,
              tabs: [
                Tab(text: 'Home'),
                Tab(text: 'Social'),
              ],
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            // Constrain TabBarView height based on available space
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top -
                100, // Adjust for TabBar and padding
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  child: homeTabContent,
                ),
                SingleChildScrollView(
                  child: SocialTabView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}