// import 'package:flutter/material.dart';
//
// // Dashboard Card Widget
// class DashboardCard extends StatelessWidget {
//   final String title;
//   final String? value; // Optional value
//   final String? percentage; // Optional percentage
//   final IconData icon;
//   final int? items; // Optional items for count-based cards
//
//   DashboardCard({
//     required this.title,
//     this.value,
//     this.percentage,
//     required this.icon,
//     this.items,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 150, // Fixed width for horizontal scrolling
//       margin: const EdgeInsets.only(right: 10),
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 30, color: Colors.blue),
//               const SizedBox(height: 8),
//               if (items != null) // Show item count if available
//                 Text(
//                   "$items",
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 )
//               else if (value != null) // Show value if available
//                 Text(
//                   value!,
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               Text(title, style: const TextStyle(color: Colors.grey)),
//               const SizedBox(height: 4),
//               if (percentage != null) // Show percentage if available
//                 Text(
//                   percentage!,
//                   style: const TextStyle(
//                       color: Colors.blue, fontWeight: FontWeight.bold),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
