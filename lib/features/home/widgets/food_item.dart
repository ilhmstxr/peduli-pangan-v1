// import 'package:flutter/material.dart';
// import '../../../views/models/food.dart';

// class FoodItem extends StatelessWidget {
//   final Food data;
//   const FoodItem({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 0.5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.network(
//                 data.imageUrl,
//                 height: 64,
//                 width: 64,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(data.name,
//                       style: const TextStyle(
//                           fontWeight: FontWeight.w700, fontSize: 16)),
//                   const SizedBox(height: 6),
//                   Text(
//                     "Pick up today ${data.pickupTime}",
//                     style: const TextStyle(fontSize: 12, color: Colors.black54),
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       const Icon(Icons.eco, size: 16),
//                       const SizedBox(width: 4),
//                       Text("${data.distance}m"),
//                       const SizedBox(width: 10),
//                       const Icon(Icons.payments, size: 16),
//                       const SizedBox(width: 4),
//                       Text("Rp ${data.price}"),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFFF2E0),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text("${data.stock} left",
//                       style:
//                           const TextStyle(color: Color(0xFFFF9800), fontSize: 12)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
