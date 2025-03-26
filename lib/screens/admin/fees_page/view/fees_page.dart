// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vidhyatra_flutter/screens/admin/admin_navbar.dart';
// import 'package:vidhyatra_flutter/screens/admin/admin_top_narbar.dart';
// import 'package:vidhyatra_flutter/screens/admin/fees_page/controller/fees_controller.dart';
//
// import '../../../../models/FeesModel.dart';
// // import 'package:vidhyatra_flutter/screens/admin/fees_page/model/fee_model.dart';
//
//
// class FeesPage extends StatelessWidget {
//   final FeeController controller = Get.put(FeeController());
//
//   FeesPage({super.key});
//
//   void _showAddFeeDialog(BuildContext context) {
//     final feeTypeController = TextEditingController();
//     final feeDescriptionController = TextEditingController();
//     final feeAmountController = TextEditingController();
//     final dueDateController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add Fee'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: feeTypeController,
//                 decoration: const InputDecoration(labelText: 'Fee Type'),
//               ),
//               TextField(
//                 controller: feeDescriptionController,
//                 decoration: const InputDecoration(labelText: 'Fee Description'),
//               ),
//               TextField(
//                 controller: feeAmountController,
//                 decoration: const InputDecoration(labelText: 'Fee Amount'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: dueDateController,
//                 decoration: const InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final fee = Fee(
//                 feeType: feeTypeController.text,
//                 feeDescription: feeDescriptionController.text,
//                 feeAmount: double.parse(feeAmountController.text),
//                 dueDate: dueDateController.text,
//               );
//               controller.addFee(fee);
//               Navigator.pop(context);
//             },
//             child: const Text('Add Fee'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(60),
//         child: AdminTopNavBar(),
//       ),
//       body: Row(
//         children: [
//           AdminNavBar(onTap: (index) {}),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Fees",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: Obx(() {
//                     if (controller.isLoading.value) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     if (controller.errorMessage.isNotEmpty) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red)),
//                             ElevatedButton(
//                               onPressed: () => controller.fetchFees(),
//                               child: const Text('Retry'),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                     if (controller.fees.isEmpty) {
//                       return const Center(child: Text('No fees found'));
//                     }
//                     return RefreshIndicator(
//                       onRefresh: controller.fetchFees,
//                       child: ListView.builder(
//                         itemCount: controller.fees.length,
//                         itemBuilder: (context, index) {
//                           final fee = controller.fees[index];
//                           return ListTile(
//                             title: Text(fee.feeType),
//                             subtitle: Text(fee.feeDescription),
//                             trailing: Text('₹${fee.feeAmount}'),
//                           );
//                         },
//                       ),
//                     );
//                   }),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddFeeDialog(context),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
