import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:smart_farming/crop_prediction/crop_prediction_model.dart';

import 'crop_details.dart';

class CropPredictionPage extends StatefulWidget {
  @override
  State<CropPredictionPage> createState() => _CropPredictionPageState();
}

class _CropPredictionPageState extends State<CropPredictionPage> {
  final formKey = GlobalKey<FormState>();
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
  late CropPrediction cropPrediction;

  Future<CropPrediction?> _predictCrop() async {
    if (!formKey.currentState!.validate()) {
      return null;
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
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      return CropPrediction.fromJson(data);
      // Map<String, dynamic> data = jsonDecode(response.body);
      // print(data);
      // predictedCrop = data['predicted_crop'];
      // top5Crops = data['top_5_crops'];

      // print("Predicted Crop: $predictedCrop");
      // print("Top 5 Predicted Crops: $top5Crops");
    } else {
      print('Failed to make prediction. Status code: ${response.statusCode}');
    }
    setState(() {});
    return null;
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
                  // height: 700,
                  width: 200,
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
                          child: Container(
                            width: 200,
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
                                labelText: 'Nitrogen',
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  borderSide:
                                      new BorderSide(color: Colors.grey),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 200,
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
                                  borderSide:
                                      new BorderSide(color: Colors.grey),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 200,
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
                                  borderSide:
                                      new BorderSide(color: Colors.grey),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 200,
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
                                  borderSide:
                                      new BorderSide(color: Colors.grey),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 200,
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
                                  borderSide:
                                      new BorderSide(color: Colors.grey),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 200,
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
                                  borderSide:
                                      new BorderSide(color: Colors.grey),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 200,
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
                                  borderSide:
                                      new BorderSide(color: Colors.grey),
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
                        ),
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () async {
                            final prediction = await _predictCrop();
                            cropPrediction=prediction!;
                            predictedCrop=prediction.predictedCrop;
                            top5Crops=prediction.top5Crops;
                            setState(() {
                              
                            });
                          },
                          child: Text('Predict'),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (predictedCrop.isNotEmpty)
                          Text(
                            "Predicted Crop: $predictedCrop",
                            style: TextStyle(fontSize: 20, color: Colors.green),
                          ),
                        const SizedBox(height: 5),
                        // if (top5Crops.isNotEmpty)
                        //   Text(
                        //     "Top 5 Crops: ${top5Crops.join(", ")}",
                        //     style: TextStyle(fontSize: 20, color: Colors.green),
                        //   ),
                        if (predictedCrop.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 20,bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CropPage(
                                              predictedCrop: predictedCrop,
                                              top5crops: top5Crops,cropPrediction: cropPrediction,
                                            )));
                              },
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black,
                                ),
                                child: Center(
                                    child: Text(
                                  'Know more',
                                  style: GoogleFonts.getFont('Didact Gothic',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26),
                                )),
                              ),
                            ),
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
