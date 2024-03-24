import 'package:flutter/material.dart';
import 'package:smart_farming/crop_prediction/crop_prediction_model.dart';

class CropPage extends StatefulWidget {
  CropPage({
    super.key,
    required this.predictedCrop,
    required this.top5crops, required this.cropPrediction,
  });
  final String predictedCrop;
  final List<dynamic> top5crops;
  final CropPrediction cropPrediction;

  @override
  State<CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Page"),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Text(
                "Predicted Crop: ${widget.predictedCrop}",
                style: TextStyle(fontSize: 20, ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Top 5 Crops: ${widget.top5crops.join(", ")}",
                style: TextStyle(fontSize: 17),
              ),SizedBox(
                height: 20,
              ),
              Text(
              'Nutrient Requirements:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.cropPrediction.nutrientRequirements.entries.map((entry) {
                final cropName = entry.key;
                final requirements = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cropName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: requirements.map((req) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('GDD: ${req['GDD']}'),
                            Text('Nitrogen Requirement: ${req['Nitrogen_requirement']}'),
                            Text('Phosphorus Requirement: ${req['Phosphorus_requirement']}'),
                            Text('Potassium Requirement: ${req['Potassium_requirement']}'),
                            SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                );
              }).toList(),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
