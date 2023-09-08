import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CostEstimationPage(),
    );
  }
}


class CostEstimationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cost Estimation Page'),
      ),
      body: Center(
        child: Text('Cost Estimation Content Goes Here'),
      ),
    );
  }
}