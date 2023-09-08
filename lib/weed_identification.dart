import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeedIdentificationPage(),
    );
  }
}

class WeedIdentificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weed Identification Page'),
      ),
      body: Center(
        child: Text('Weed Identification Content Goes Here'),
      ),
    );
  }
}