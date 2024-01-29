import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_farming/functions.dart';
import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: CropPredictionPage(),
//     );
//   }
// }

class CropPredictionPage extends StatefulWidget {
  @override
  State<CropPredictionPage> createState() => _CropPredictionPageState();
}

class _CropPredictionPageState extends State<CropPredictionPage> {
  final _numberController = TextEditingController();
  String url = '';
  var data;
  String output = 'initial';
  String predictedCrop="";
  List<dynamic> top5Crops=[];
   TextEditingController _nController = TextEditingController();
  TextEditingController _pController = TextEditingController();
  TextEditingController _kController = TextEditingController();
  TextEditingController _temperatureController = TextEditingController();
  TextEditingController _humidityController = TextEditingController();
  TextEditingController _phController = TextEditingController();
  TextEditingController _rainfallController = TextEditingController();

  Future<void> _predictCrop() async {
    final apiUrl = 'http://johnhonai.pythonanywhere.com/predict'; 
    print("${_nController.text},${_pController.text},${_kController.text},${_temperatureController.text},${_humidityController.text},${_phController.text},${_rainfallController.text}");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "N": double.parse(_nController.text),
        "P": double.parse(_pController.text),
        "k": double.parse(_kController.text),
        "temperature": double.parse(_temperatureController.text),
        "humidity": double.parse(_humidityController.text),
        "ph": double.parse(_phController.text),
        "rainfall": double.parse(_rainfallController.text),
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      predictedCrop = data['predicted_crop'];
      top5Crops = data['top_5_crops'];
      
     
      print("Predicted Crop: $predictedCrop");
      print("Top 5 Predicted Crops: $top5Crops");
    } else {
     
      print('Failed to make prediction. Status code: ${response.statusCode}');
    }
    setState(() {
      
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Crop Prediction Page'),
        ),
        body: Column(
          children: [
            // TextField(
            //   // controller: _numberController,
            //   onChanged: (value) {
            //     url = "http://johnhonai.pythonanywhere.com/api?query=${value.toString()}";
            //   },
            //   decoration: InputDecoration(
            //     labelText: 'Letter',
            //     labelStyle: const TextStyle(
            //       color: Colors.white,
            //       fontSize: 20, // Increased font size
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(6),
            //       borderSide: const BorderSide(color: Colors.white),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(6),
            //       borderSide: const BorderSide(color: Colors.lightGreen),
            //     ),
            //     border: const OutlineInputBorder(
            //       borderRadius: BorderRadius.horizontal(
            //         left: Radius.circular(15),
            //         right: Radius.circular(3),
            //       ),
            //       borderSide: BorderSide(color: Colors.white, width: 2.0),
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // Container(
            //   padding: const EdgeInsets.only(left: 10, right: 10),
            //   height: 60,
            //   width: 300,
            //   child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.black,
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10)),
            //       ),
            //       child: Text(
            //         'Crop Prediction',
            //         style: GoogleFonts.getFont('Didact Gothic',
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 24),
            //       ),
            //       onPressed: () async {
            //         print(url);
            //         print("here");
            //         data = await fetchdata(url);
            //         print(data);
            //         var decoded= jsonDecode(data);
            //         setState(() {
            //           output = decoded['output'];
            //         });
            //       }),
            // ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                  controller: _nController,
                  decoration: InputDecoration(labelText: 'N'),
                  keyboardType: TextInputType.number,
                ),
            ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _pController,
                  decoration: InputDecoration(labelText: 'P'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _kController,
                  decoration: InputDecoration(labelText: 'k'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _temperatureController,
                  decoration: InputDecoration(labelText: 'Temperature'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _humidityController,
                  decoration: InputDecoration(labelText: 'Humidity'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _phController,
                  decoration: InputDecoration(labelText: 'pH'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _rainfallController,
                  decoration: InputDecoration(labelText: 'Rainfall'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _predictCrop,
                child: Text('Predict'),
              ),
            const SizedBox(
              height: 20,
            ),
            Text(
              predictedCrop,
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 10,),
            Text(
              top5Crops.toString(),
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
          ],
        ));
  }
}
