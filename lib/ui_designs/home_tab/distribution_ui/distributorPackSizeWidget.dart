// import 'package:flutter/material.dart';
// import 'package:tulip_app/model/distributor_model/distributor_products_list.dart';
// import 'package:tulip_app/util/extensions.dart';
//
// class DistributorPackSize extends StatefulWidget {
//   final List<DistPackSize> item;
//   final ValueChanged<DistPackSize?> onPackSizeSelected;
//
//   const DistributorPackSize({Key? key, required this.item, required this.onPackSizeSelected}) : super(key: key);
//
//   @override
//   _DistributorPackSizeState createState() => _DistributorPackSizeState();
// }
//
// class _DistributorPackSizeState extends State<DistributorPackSize> {
//   DistPackSize? packSizeSelected;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 4.h, // Adjust the height as needed
//       width: 38.w, // Adjust the width as needed
//       padding: const EdgeInsets.symmetric(horizontal: 7),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//               offset: const Offset(0, 1),
//               color:
//               const Color(0xffC3C3C3).withOpacity(0.25),
//               blurRadius: 4,
//               spreadRadius: 0),
//           BoxShadow(
//               offset: const Offset(0, -1),
//               color:
//               const Color(0xffC3C3C3).withOpacity(0.25),
//               blurRadius: 4,
//               spreadRadius: 0),
//         ],
//         borderRadius: BorderRadius.circular(3),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<DistPackSize>(
//           value: packSizeSelected,
//           hint: const Text(
//             "Select Pack Size",
//             style: TextStyle(fontSize: 11),
//           ),
//           items: widget.item.map((item) {
//             return DropdownMenuItem(
//               value: item,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 3.0),
//                 child: Text(
//                   item.quantity.toString(),
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ),
//             );
//           }).toList(),
//           onChanged: (newValue) {
//             setState(() {
//               packSizeSelected = newValue!;
//               widget.onPackSizeSelected(newValue);
//             });
//           },
//         ),
//       ),
//     );
//   }
// }
