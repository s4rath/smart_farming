import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_farming/crop_prediction/Automatic_crop.dart';
import 'package:smart_farming/crop_prediction/crop_prediction.dart';

class CropPredictionHome extends StatefulWidget {
  const CropPredictionHome({super.key});

  @override
  State<CropPredictionHome> createState() => _CropPredictionHomeState();
}

class _CropPredictionHomeState extends State<CropPredictionHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Crop Prediction Home")),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                    'Crop Prediction Manual',
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
            SizedBox(
              height: 20,
            ),
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
                    'Crop Prediction Automatic',
                    style: GoogleFonts.getFont('Didact Gothic',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CropPredictionAuto(),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
