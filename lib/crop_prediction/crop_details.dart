import 'package:flutter/material.dart';

class CropPage extends StatefulWidget {
  CropPage({
    super.key,
    required this.predictedCrop,
    required this.top5crops,
  });
  final String predictedCrop;
  final List<dynamic> top5crops;

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
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Top 5 Crops: ${widget.top5crops.join(", ")}",
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
