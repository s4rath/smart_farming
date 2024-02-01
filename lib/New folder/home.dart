// import 'package:flutter/material.dart';
// import 'cost_estimation.dart';
// import 'pest_identification.dart';
// import 'weed_identification.dart';
// import 'crop_prediction.dart';
// import 'iot.dart'; // Import the IoTControlPage
// import 'dart:math';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   final List<String> imagePaths = [
//     'assets/images/crop.png',
//     'assets/images/weed.png',
//     'assets/images/pest.png',
//     'assets/images/cost.png',
//     'assets/images/iot.png', // Add IoT icon
//   ];

//   final List<String> pageNames = [
//     'Crop Prediction',
//     'Weed Identification',
//     'Pest Identification',
//     'Cost Estimation',
//     'IoT Control', // Add IoT label
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Page'),
//       ),
//       body: Stack(
//         children: [
//           // Background Image with Black Overlay
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             child: Image.asset(
//               'assets/images/Farmer.jpg',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Container(
//             color: Colors.black.withOpacity(0.7),
//           ),
//           Center(
//             child: Stack(
//               alignment: Alignment.centerRight,
//               children: buildCircularIcons(context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List<Widget> buildCircularIcons(BuildContext context) {
//     final double radius = 150.0;
//     final double angleStep = 2 * pi / imagePaths.length;
//     List<Widget> iconWidgets = [];

//     for (int i = 0; i < imagePaths.length; i++) {
//       final double x = cos(i * angleStep) * radius;
//       final double y = sin(i * angleStep) * radius;

//       iconWidgets.add(
//         Positioned(
//           right: MediaQuery.of(context).size.width / 2 - x - 50,
//           top: MediaQuery.of(context).size.height / 2 + y - 50,
//           child: GestureDetector(
//             onTap: () {
//               navigateToPage(context, i);
//             },
//             child: buildIcon(imagePaths[i], pageNames[i]),
//           ),
//         ),
//       );
//     }

//     return iconWidgets;
//   }

//   void navigateToPage(BuildContext context, int index) {
//     switch (index) {
//       case 0:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CropPredictionPage(),
//           ),
//         );
//         break;
//       case 1:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => WeedIdentificationPage(),
//           ),
//         );
//         break;
//       case 2:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PestIdentificationPage(),
//           ),
//         );
//         break;
//       case 3:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CostEstimationPage(),
//           ),
//         );
//         break;
//       case 4:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => IoTControlPage(),
//           ),
//         );
//         break;
//     }
//   }

//   Widget buildIcon(String imagePath, String label) {
//     return Column(
//       children: [
//         Image.asset(
//           imagePath,
//           width: 100,
//           height: 100,
//         ),
//         SizedBox(height: 10),
//         Text(
//           label,
//           style: TextStyle(fontSize: 16, color: Colors.white),
//         ),
//       ],
//     );
//   }
// }
