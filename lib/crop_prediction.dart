import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CropPredictionPage(),
    );
  }
}
class CropPredictionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Prediction Page'),
      ),
      body: Center(
        child: Text('Crop Prediction Content Goes Here'),
      ),
    );
  }
}



