// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../controllers/ChangePasswordController.dart';
//
// class ChangePassword extends StatelessWidget {
//   final ChangePasswordController controller = Get.put(ChangePasswordController());
//
//   final TextEditingController currentPasswordController = TextEditingController();
//   final TextEditingController newPasswordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         title: Text(
//           "Change Password",
//           style: GoogleFonts.poppins(color: Colors.white, fontSize: 19),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//         backgroundColor: const Color(0xFF186CAC),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Column(
//           children: [
//             const SizedBox(height: 50),
//
//             _buildPasswordField(
//               label: 'Current Password',
//               controller: currentPasswordController,
//             ),
//             const SizedBox(height: 20),
//
//             _buildPasswordField(
//               label: 'New Password',
//               controller: newPasswordController,
//             ),
//             const SizedBox(height: 20),
//
//             _buildPasswordField(
//               label: 'Confirm New Password',
//               controller: confirmPasswordController,
//             ),
//             const SizedBox(height: 40),
//
//             Obx(() => controller.isLoading.value
//                 ? const CircularProgressIndicator()
//                 : SizedBox(
//               width: 160,
//               child: InkWell(
//                 onTap: () {
//                   controller.changePassword(
//                     currentPasswordController.text,
//                     newPasswordController.text,
//                     confirmPasswordController.text,
//                   );
//                 },
//                 borderRadius: BorderRadius.circular(15),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF186CAC),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Change',
//                       style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             )),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPasswordField({
//     required String label,
//     required TextEditingController controller,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.poppins(
//             fontSize: 14,
//             color: Colors.grey[600],
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           obscureText: true,
//           decoration: InputDecoration(
//             hintText: label,
//             hintStyle: TextStyle(
//               color: Colors.grey[400],
//               fontFamily: GoogleFonts.poppins().fontFamily,
//             ),
//             filled: true,
//             fillColor: Colors.white,
//             contentPadding: const EdgeInsets.symmetric(
//               vertical: 16,
//               horizontal: 20,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(
//                 color: Color(0xFF186CAC),
//                 width: 2,
//               ),
//             ),
//             prefixIcon: Icon(
//               Icons.lock_outline,
//               color: Colors.grey[400],
//               size: 22,
//             ),
//           ),
//           cursorColor: const Color(0xFF186CAC),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/ChangePasswordController.dart';

class ChangePassword extends StatelessWidget {
  final ChangePasswordController controller = Get.put(ChangePasswordController());

  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // RxBool variables to control password visibility
  final RxBool currentPasswordVisible = false.obs;
  final RxBool newPasswordVisible = false.obs;
  final RxBool confirmPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 19),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF186CAC),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 50),

            _buildPasswordField(
              label: 'Current Password',
              controller: currentPasswordController,
              isObscured: currentPasswordVisible,
            ),
            const SizedBox(height: 20),

            _buildPasswordField(
              label: 'New Password',
              controller: newPasswordController,
              isObscured: newPasswordVisible,
            ),
            const SizedBox(height: 20),

            _buildPasswordField(
              label: 'Confirm New Password',
              controller: confirmPasswordController,
              isObscured: confirmPasswordVisible,
            ),
            const SizedBox(height: 40),

            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : SizedBox(
              width: 160,
              child: InkWell(
                onTap: () {
                  controller.changePassword(
                    currentPasswordController.text,
                    newPasswordController.text,
                    confirmPasswordController.text,
                  );
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF186CAC),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Change',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            )),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required RxBool isObscured,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => TextField(
          controller: controller,
          obscureText: !isObscured.value,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF186CAC),
                width: 2,
              ),
            ),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.grey[400],
              size: 22,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isObscured.value ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[400],
                size: 22,
              ),
              onPressed: () {
                isObscured.value = !isObscured.value;
              },
            ),
          ),
          cursorColor: const Color(0xFF186CAC),
        )),
      ],
    );
  }
}