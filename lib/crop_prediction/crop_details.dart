
import 'package:flutter/material.dart';
import 'package:smart_farming/crop_prediction/crop_prediction_model.dart';
import 'package:google_fonts/google_fonts.dart';

class CropPage extends StatelessWidget {
  CropPage({
    Key? key,
    required this.predictedCrop,
    required this.top5crops,
    required this.cropPrediction,
  }) : super(key: key);

  final String predictedCrop;
  final List<dynamic> top5crops;
  final CropPrediction cropPrediction;

  String capitalizeFirstLetter(String text) {
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Page"),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/wp1886339.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildSectionHeading("Predicted Best Crop:"),
                    SizedBox(
                      width: double.infinity,
                      child: _buildSectionCard(
                        Center(
                          child: Text(
                            capitalizeFirstLetter(predictedCrop),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Center( // Centering text here
                      child: Text(
                        'Top 5 Crops with Nutrient Requirements:',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: cropPrediction.nutrientRequirements.entries
                            .map((entry) {
                          final cropName = entry.key;
                          final requirements = entry.value;

                          return _buildNutrientRequirementsCard(
                              capitalizeFirstLetter(cropName), requirements);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeading(String heading) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        heading,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.black,
              offset: Offset(0, 0),
            ),
          ],
        ),
      ),
      );

  }

  Widget _buildSectionCard(Widget content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white.withOpacity(0.3), // Set opacity here
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: content,
      ),
    );
  }

  Widget _buildNutrientRequirementsCard(
      String cropName, List<Map<String, dynamic>> requirements) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white.withOpacity(0.3), // Set opacity here
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cropName,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.green,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ...requirements.map((req) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('GDD: ${req['GDD']}', style: TextStyle(color: Colors.white)), // Text color
                  Text(
                      'Nitrogen Requirement: ${req['Nitrogen_requirement']}', style: TextStyle(color: Colors.white)), // Text color
                  Text(
                      'Phosphorus Requirement: ${req['Phosphorus_requirement']}', style: TextStyle(color: Colors.white)), // Text color
                  Text('Potassium Requirement: ${req['Potassium_requirement']}', style: TextStyle(color: Colors.white)), // Text color
                  SizedBox(height: 10),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
