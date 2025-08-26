// import 'dart:math' as math;
//
// import 'package:flutter/material.dart';
// import 'dart:math';
//
// import '../../domain/models/section.dart';
//
// class ExerciseWidget extends StatelessWidget {
//   final int index;
//   final Section data;
//
//   const ExerciseWidget({
//     super.key,
//     required this.index,
//     required this.data
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(
//         bottom: index != 8 ? 24.0 : 0,
//         left: getLeft(index),
//         right: getRight(index),
//       ),
//       decoration: BoxDecoration(
//         border: const Border(
//           bottom: BorderSide(color: Colors.white10, width: 6.0),
//         ),
//         borderRadius: BorderRadius.circular(36.0),
//       ),
//       child: ElevatedButton(
//         onPressed: () {},
//         style: ElevatedButton.styleFrom(
//           backgroundColor: data.color,
//           fixedSize: const Size(56, 48),
//           elevation: 0,
//           padding: EdgeInsets.zero,
//           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           minimumSize: Size.zero,
//         ),
//         child: Container(
//           width: 24.0,
//           height: 24.0,
//           color: Colors.yellow, // A visual indicator
//         ),
//       ),
//     );
//   }
// }
//
// double getLeft(int indice) {
//   const margin = 80.0;
//   int pos = indice % 9;
//
//   if (pos == 1) {
//     return margin;
//   }
//   if (pos == 2) {
//     return margin * 2;
//   }
//   if (pos == 3) {
//     return margin;
//   }
//
//   return 0.0;
// }
//
// double getRight(int indice) {
//   const margin = 80.0;
//   int pos = indice % 9;
//
//   if (pos == 5) {
//     return margin;
//   }
//   if (pos == 6) {
//     return margin * 2;
//   }
//   if (pos == 7) {
//     return margin;
//   }
//
//   return 0.0;
// }
