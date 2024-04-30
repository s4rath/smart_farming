import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_farming/crop_prediction/Automatic_climate.dart';
import 'package:smart_farming/crop_prediction/Automatic_crop.dart';
import 'package:smart_farming/crop_prediction/crop_prediction.dart';
import 'package:smart_farming/screens/locationtest.dart';

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
        title: Text("Crop Prediction Home",style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 58, 143, 188),

        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/wp1886339.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5), // Black overlay
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 60),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Dashboard',
                      style: GoogleFonts.getFont(
                        'Didact Gothic',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 10),
                    GridButton(
                      buttonText: ' Manual Crop Prediction',
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CropPredictionPage(),
                          ),
                        );
                      },
                      imagePath: 'assets/images/manual-modified.png',
                    ),
                    SizedBox(height: 10),
                    GridButton(
                      buttonText: 'Automated Crop Prediction (Soil)',
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CropPredictionAuto(),
                          ),
                        );
                      },
                      imagePath: 'assets/images/soil.png',
                    ),
                    SizedBox(height: 10),
                    GridButton(
                      buttonText: 'Automated Crop Prediction (Climate)',
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CropAutomaticClimate(),
                          ),
                        );
                      },
                      imagePath: 'assets/images/auto-modified.png',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Warning: ',
                  style: TextStyle(
                    color: Colors.red, // Set color of 'Warning' to red
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text:
                      '\n Automated mode uses general area data \n & may differ from your specific farm area',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final String? additionalText;
  final String imagePath;

  const GridButton({
    required this.buttonText,
    required this.onPressed,
    this.additionalText,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10.0),
        ),
        width: 150,
        height: 150,
        child: InkWell(
          onTap: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 100,
                height: 80,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 10),
              Text(
                buttonText,
                style: GoogleFonts.getFont(
                  'Didact Gothic',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              if (additionalText != null)
                Text(
                  additionalText!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
