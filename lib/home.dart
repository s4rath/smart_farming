import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cost_estimation.dart';
import 'pest_identification.dart';
import 'weed_identification.dart';
import 'crop_prediction.dart';
import 'dart:math';

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

class HomePage extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/crop.png',
    'assets/images/weed.png',
    'assets/images/pest.png',
    'assets/images/cost.png',
  ];

  final List<String> pageNames = [
    'Crop Prediction',
    'Weed Identification',
    'Pest Identification',
    'Cost Estimation',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/1598244.jpg'), // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 60,
                width: 300,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Crop Prediction',
                      style: GoogleFonts.getFont('Didact Gothic',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CropPredictionPage(),
                        ),
                      );
                    }),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 60,
                width: 300,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Weed Identification',
                      style: GoogleFonts.getFont('Didact Gothic',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeedIdentificationPage(),
                        ),
                      );
                    }),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 60,
                width: 300,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Pest Identification',
                      style: GoogleFonts.getFont('Didact Gothic',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PestIdentificationPage(),
                        ),
                      );
                    }),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 60,
                width: 300,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Cost Estimation',
                      style: GoogleFonts.getFont('Didact Gothic',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CostEstimationPage(),
                        ),
                      );
                    }),
              ),
            ],
          ),
        )
        // Stack(
        //   children: [
        //     // Background Image with Black Overlay
        //     Container(
        //       width: double.infinity,
        //       height: double.infinity,
        //       child: Image.asset(
        //         'assets/images/Farmer.jpg',
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //     Container(
        //       color: Colors.black.withOpacity(0.7), // Adjust opacity as needed
        //     ),
        //     Center(
        //       child: Stack(
        //         alignment: Alignment.centerRight,
        //         children: buildCircularIcons(context),
        //       ),
        //     ),
        //       Container(
        //               padding: EdgeInsets.only(left: 10, right: 10),
        //               height: 60,
        //               width: 150,
        //               child: ElevatedButton(
        //                   style: ElevatedButton.styleFrom(
        //                     backgroundColor: Colors.black,
        //                     shape: RoundedRectangleBorder(
        //                         borderRadius: BorderRadius.circular(10)),
        //                   ),
        //                   child: Text(
        //                     'Gallery',
        //                     style: GoogleFonts.getFont('Didact Gothic',
        //                         color: Colors.white,
        //                         fontWeight: FontWeight.bold,
        //                         fontSize: 24),
        //                   ),
        //                   onPressed: () async {
        //                     pickimage_gallery();
        //                   }),
        //             ),
        //   ],
        // ),
        );
  }

  List<Widget> buildCircularIcons(BuildContext context) {
    final double radius = 150.0; // Adjust this radius as needed
    final double angleStep = 2 * pi / imagePaths.length;
    List<Widget> iconWidgets = [];

    for (int i = 0; i < imagePaths.length; i++) {
      final double x = cos(i * angleStep) * radius;
      final double y = sin(i * angleStep) * radius;

      iconWidgets.add(
        Positioned(
          right: MediaQuery.of(context).size.width / 2 -
              x -
              50, // Adjust icon size and positioning
          top: MediaQuery.of(context).size.height / 2 +
              y -
              50, // Adjust icon size and positioning
          child: GestureDetector(
            onTap: () {
              navigateToPage(context, i);
            },
            child: buildIcon(imagePaths[i], pageNames[i]),
          ),
        ),
      );
    }

    return iconWidgets;
  }

  void navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropPredictionPage(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeedIdentificationPage(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PestIdentificationPage(),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CostEstimationPage(),
          ),
        );
        break;
    }
  }

  Widget buildIcon(String imagePath, String label) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: 100,
          height: 100,
        ),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
