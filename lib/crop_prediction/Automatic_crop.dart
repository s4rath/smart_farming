import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:smart_farming/crop_prediction/crop_details.dart';
import 'package:smart_farming/crop_prediction/crop_prediction_model.dart';

class CropPredictionAuto extends StatefulWidget {
  const CropPredictionAuto({super.key});

  @override
  State<CropPredictionAuto> createState() => _CropPredictionAutoState();
}

class _CropPredictionAutoState extends State<CropPredictionAuto>
    with WidgetsBindingObserver {
  Position? _currentPosition;
  double? latitude;
  double? longitude;
  final formKey = GlobalKey<FormState>();
  String predictedCrop = "";
  String dewPoint="";
  List<dynamic> top5Crops = [];
  TextEditingController _nController = TextEditingController();
  TextEditingController _pController = TextEditingController();
  TextEditingController _kController = TextEditingController();
  TextEditingController _phController = TextEditingController();
  TextEditingController _rainfallController = TextEditingController();
  String temperature = '';
  String humidity = '';
  late CropPrediction cropPrediction;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLocationPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkLocationPermission();
    }
  }


  Future<void> getWeatherData(String latitude, String longitude) async {
    final apiKey = 'c6e2e5fe63e2405592f190738243101';
    final apiUrl =
        'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$latitude,$longitude';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Map<String, dynamic> currentData = data['current'];
        final String temp = currentData['temp_c'].toString();
        final String hum = currentData['humidity'].toString();

        // Extract dewpoint from the forecast
        final Map<String, dynamic> forecastData = data['forecast']['forecastday'][0]['hour'][0];
        final String dewpoint_c = forecastData['dewpoint_c'].toString();
        final String dewpoint_f = forecastData['dewpoint_f'].toString();
        print("$temp $hum $dewpoint_c $dewpoint_f");

        setState(() {
          temperature = temp;
          humidity = hum;
          dewPoint = dewpoint_c;
        });
      } else {
        throw Exception(
            'Failed to load weather data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching weather data: $error');
    }
  }

  Future<CropPrediction?> _predictCrop() async {
    if (!formKey.currentState!.validate()) {
      return null;
    }
    print("here");
    if (temperature.isEmpty || humidity.isEmpty) {
      print('Temperature and humidity cannot be empty.');
      return null;
    }
    double? tempValue = double.tryParse(temperature);
    double? humidityValue = double.tryParse(humidity);
    if (tempValue == null || humidityValue == null) {
      print('Invalid temperature or humidity value.');
      return null;
    }
    final apiUrl = 'http://johnhona1.pythonanywhere.com/predict';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "N": double.parse(_nController.text),
        "P": double.parse(_pController.text),
        "k": double.parse(_kController.text),
        "temperature": tempValue,
        "humidity": humidityValue,
        "ph": double.parse(_phController.text),
        "rainfall": double.parse(_rainfallController.text),
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      return CropPrediction.fromJson(data);
      // Map<String, dynamic> data = jsonDecode(response.body);
      // predictedCrop = data['predicted_crop'];
      // top5Crops = data['top_5_crops'];

      // print("Predicted Crop: $predictedCrop");
      // print("Top 5 Predicted Crops: $top5Crops");
    } else {
      print('Failed to make prediction. Status code: ${response.statusCode}');
    }
    return null;
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    _getCurrentLocation();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        latitude = position.latitude;
        longitude = position.longitude;
      });
      getWeatherData(
          latitude!.toStringAsFixed(3), longitude!.toStringAsFixed(3));
      print(
          "${latitude!.toStringAsFixed(3)}   ${longitude!.toStringAsFixed(3)}");

      // getWeatherData(latitude!.toStringAsFixed(3), longitude!.toStringAsFixed(3));
      // _predictCrop();
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crop Prediction Automatic"),
      ),
      body:

      Form(
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
