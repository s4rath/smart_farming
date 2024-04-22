import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_farming/crop_prediction/Automatic_climate.dart';
import 'package:smart_farming/crop_prediction/Automatic_crop.dart';
import 'package:smart_farming/crop_prediction/crop_prediction.dart';
import 'package:smart_farming/screens/locationtest.dart';

// class CropPredictionHome extends StatefulWidget {
//   const CropPredictionHome({super.key});

//   @override
//   State<CropPredictionHome> createState() => _CropPredictionHomeState();
// }

// class _CropPredictionHomeState extends State<CropPredictionHome> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Crop Prediction Home")),
//       body: Container(
//         width: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               padding: EdgeInsets.only(left: 10, right: 10),
//               height: 60,
//               width: 300,
//               child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                   child: Text(
//                     'Crop Prediction Manual',
//                     style: GoogleFonts.getFont('Didact Gothic',
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 24),
//                   ),
//                   onPressed: () async {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CropPredictionPage(),
//                       ),
//                     );
//                   }),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               padding: EdgeInsets.only(left: 10, right: 10),
//               height: 60,
//               width: 300,
//               child: Stack(
//                 children: [
//                   Container(
//                     // padding: EdgeInsets.only(left: 10, right: 10),
//                     height: 60,
//                     width: 300,
//                     child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                         ),
//                         child: Text(
//                           'Crop Prediction Automatic',
//                           style: GoogleFonts.getFont('Didact Gothic',
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 24),
//                         ),
//                         onPressed: () async {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CropPredictionAuto(),
//                             ),
//                           );
//                         }),
//                   ),
//                   Positioned(
//                     bottom: 5, right: 20,
//                     // left: 30,
//                     child: Text(
//                       'By soil conditions',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               padding: EdgeInsets.only(left: 10, right: 10),
//               height: 60,
//               width: 300,
//               child: Stack(
//                 children: [
//                   Container(
//                     // padding: EdgeInsets.only(left: 10, right: 10),
//                     height: 60,
//                     width: 300,
//                     child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                         ),
//                         child: Text(
//                           'Crop Prediction Automatic',
//                           style: GoogleFonts.getFont('Didact Gothic',
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 24),
//                         ),
//                         onPressed: () async {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CropAutomaticClimate(),
//                             ),
//                           );
//                         }),
//                   ),
//                   Positioned(
//                     bottom: 5, right: 20,
//                     // left: 30,
//                     child: Text(
//                       'By climatic conditions',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // ElevatedButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){return LocationTest();}));}, child: Text("location test"))
//           ],
//         ),
//       ),
//     );
//   }
// }

class CropPredictionHome extends StatefulWidget {
  const CropPredictionHome({Key? key}) : super(key: key);

  @override
  State<CropPredictionHome> createState() => _CropPredictionHomeState();
}

class _CropPredictionHomeState extends State<CropPredictionHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crop Prediction Home"),
        backgroundColor: Color.fromARGB(255, 221, 220, 218),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/cover.jpeg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.1),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GridButton(
                    buttonText: 'Crop Prediction Manual',
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CropPredictionPage(),
                        ),
                      );
                    },
                  ),
                  GridButton(
                    buttonText: 'Crop Prediction Automatic (Soil)',
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CropPredictionAuto(),
                        ),
                      );
                    },
                    additionalText: 'By soil conditions',
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GridButton(
                buttonText: 'Crop Prediction Automatic (Climate)',
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CropAutomaticClimate(),
                    ),
                  );
                },
                additionalText: 'By climatic conditions',
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class GridButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final String? additionalText;

  const GridButton({
    required this.buttonText,
    required this.onPressed,
    this.additionalText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 31, 29, 29).withOpacity(0.4),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.all(3),
      width: 190,
      height: 200,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/1598244.jpg',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Text(
                  buttonText,
                  style: GoogleFonts.getFont(
                    'Didact Gothic',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (additionalText != null)
                  Text(
                    additionalText!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
