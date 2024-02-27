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
  final formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  String url = '';
  // var data;
  // String output = 'initial';
  String predictedCrop = "";
  List<dynamic> top5Crops = [];
  TextEditingController _nController = TextEditingController();
  TextEditingController _pController = TextEditingController();
  TextEditingController _kController = TextEditingController();
  TextEditingController _temperatureController = TextEditingController();
  TextEditingController _humidityController = TextEditingController();
  TextEditingController _phController = TextEditingController();
  TextEditingController _rainfallController = TextEditingController();

  Future<void> _predictCrop() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final apiUrl = 'http://johnhona1.pythonanywhere.com/predict';
    print(
        "${_nController.text},${_pController.text},${_kController.text},${_temperatureController.text},${_humidityController.text},${_phController.text},${_rainfallController.text}");
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Prediction Page'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                // color: Colors.blue.shade800,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/wp1886339.jpg'), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  // height: MediaQuery.of(context).size.height / 1.3,
                  width: MediaQuery.of(context).size.width / 1.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, right: 8, left: 8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _nController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Nitrogen', hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                              // prefixIcon: Icon(
                              //   Icons.phone,
                              //   color: Style.grey,
                              // ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: new BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _pController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Phosphorous', hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                              // prefixIcon: Icon(
                              //   Icons.phone,
                              //   color: Style.grey,
                              // ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: new BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _kController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Potassium', hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                              // prefixIcon: Icon(
                              //   Icons.phone,
                              //   color: Style.grey,
                              // ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: new BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _temperatureController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Temperature', hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                              // prefixIcon: Icon(
                              //   Icons.phone,
                              //   color: Style.grey,
                              // ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: new BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _humidityController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Humidity', hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                              // prefixIcon: Icon(
                              //   Icons.phone,
                              //   color: Style.grey,
                              // ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: new BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _phController,
                            decoration: InputDecoration(
                              labelText: 'pH',
                              hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                              // prefixIcon: Icon(
                              //   Icons.phone,
                              //   color: Style.grey,
                              // ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: new BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                return null;
                              }
                            },
                            // decoration: InputDecoration(),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _rainfallController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Rainfall', hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                              // prefixIcon: Icon(
                              //   Icons.phone,
                              //   color: Style.grey,
                              // ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: new BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
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
                        predictedCrop == ""
                            ? Text("")
                            : Text(
                                "predicted crop : ${predictedCrop}",
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.green),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        top5Crops.isEmpty
                            ? Text("")
                            : Text(
                                "Top 5 crops: ${top5Crops.join(", ")}",
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.green),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
