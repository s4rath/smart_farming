import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:smart_farming/crop_prediction/crop_prediction_model.dart';
import 'package:smart_farming/services/firebase_fun.dart';

import 'crop_details.dart';

class CropPredictionPage extends StatefulWidget {
  @override
  State<CropPredictionPage> createState() => _CropPredictionPageState();
}

class _CropPredictionPageState extends State<CropPredictionPage> {
  final formKey = GlobalKey<FormState>();
  String url = '';

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
    } else {
      print('Failed to make prediction. Status code: ${response.statusCode}');
    }
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Crop Prediction Manual',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 58, 143, 188),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/wp1886339.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Black overlay
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 60.0), // Add padding to the top
                child: Container(
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Heading
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 0.1,
                        ),
                        child: Text(
                          'Crop Prediction by Manual Recognition',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 200,
                          height: 35,
                          child: TextFormField(
                            controller: _nController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                double nitrogenValue = double.parse(value);
                                if (nitrogenValue != null &&
                                    (nitrogenValue < 0 ||
                                        nitrogenValue > 140)) {
                                  return "Value must be between 0 and 140";
                                }
                                return null;
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Nitrogen',
                              hintText: '',
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                borderSide: new BorderSide(color: Colors.green),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.green),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 200,
                          height: 35,
                          child: TextFormField(
                            controller: _pController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                double phosphorusValue = double.parse(value);
                                if (phosphorusValue != null &&
                                    (phosphorusValue < 0 ||
                                        phosphorusValue > 145)) {
                                  return "Value must be between 0 and 145";
                                }
                                return null;
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Phosphorous',
                              hintText: '',
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                borderSide: new BorderSide(color: Colors.green),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.green),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 200,
                          height: 35,
                          child: TextFormField(
                            controller: _kController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                double potassiumValue = double.parse(value);
                                if (potassiumValue != null &&
                                    (potassiumValue < 0 ||
                                        potassiumValue > 205)) {
                                  return "Value must be between 0 and 205";
                                }
                                return null;
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Potassium',
                              hintText: '',
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                borderSide: new BorderSide(color: Colors.green),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.green),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 200,
                          height: 35,
                          child: TextFormField(
                            controller: _temperatureController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                double temperatureValue = double.parse(value);
                                if (temperatureValue != null &&
                                    temperatureValue >= 50) {
                                  return "Enter valid temperature in celsius";
                                }
                                return null;
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Temperature',
                              hintText: '',
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                borderSide: new BorderSide(color: Colors.green),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.green),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 200,
                          height: 35,
                          child: TextFormField(
                            controller: _humidityController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                double humidityValue = double.parse(value);
                                if (humidityValue != null &&
                                    (humidityValue < 14 ||
                                        humidityValue > 99)) {
                                  return "Humidity must be between 14 and 99";
                                }
                                return null;
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Humidity',
                              hintText: '',
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                borderSide: new BorderSide(color: Colors.green),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.green),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 200,
                          height: 35,
                          child: TextFormField(
                            controller: _phController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'pH',
                              hintText: '',
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                borderSide: new BorderSide(color: Colors.green),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.green),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                double phValue = double.parse(value);
                                if (phValue != null &&
                                    (phValue < 1 || phValue > 14)) {
                                  return "pH must be between 1 and 14";
                                }
                                return null;
                              }
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 200,
                          height: 35,
                          child: TextFormField(
                            controller: _rainfallController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                double rainfallValue = double.parse(value);
                                if (rainfallValue != null &&
                                    (rainfallValue < 0 ||
                                        rainfallValue > 400)) {
                                  return "Rainfall must be greater than 0 and less than 400 ";
                                }
                                return null;
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Rainfall',
                              hintText: '',
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                borderSide: new BorderSide(color: Colors.green),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.green),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      SizedBox(height: 3.5),
                      ElevatedButton(
                        onPressed: () async {
                          final prediction = await _predictCrop();
                          if (prediction != null) {
                            cropPrediction = prediction;
                            predictedCrop = prediction.predictedCrop;
                            top5Crops = prediction.top5Crops;
                            await functionDBCall(
                                "Crop Prediction Manual", predictedCrop);
                            setState(() {});
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 50),
                          // Adjust padding as needed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.green,
                          // Background color
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ), // Text style
                        ),
                        child: Text(
                          'Predict',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      const SizedBox(
                        height: 3,
                      ),
                      if (predictedCrop.isNotEmpty)
                        Text(
                          "Predicted Crop: $predictedCrop",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      if (predictedCrop.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 3, left: 5, right: 5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CropPage(
                                            predictedCrop: predictedCrop,
                                            top5crops: top5Crops,
                                            cropPrediction: cropPrediction,
                                          )));
                            },
                            child: Container(
                              height: 15,
                              width: 143,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(
                                    0.2), // Button background color
                                borderRadius: BorderRadius.circular(
                                    8), // Optional: Button border radius
                              ),
                              child: Center(
                                child: Text(
                                  'Know more',
                                  style: GoogleFonts.getFont(
                                    'Didact Gothic',
                                    color: Colors.white, // Button text color
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 1.8,
                      ),
                    ],
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
