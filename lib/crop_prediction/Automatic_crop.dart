import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class CropPredictionAuto extends StatefulWidget {
  const CropPredictionAuto({super.key});

  @override
  State<CropPredictionAuto> createState() => _CropPredictionAutoState();
}

class _CropPredictionAutoState extends State<CropPredictionAuto> with WidgetsBindingObserver{
  Position? _currentPosition;
  double? latitude;
  double? longitude;
  final formKey = GlobalKey<FormState>();
  String predictedCrop = "";
  List<dynamic> top5Crops = [];
  TextEditingController _nController = TextEditingController();
  TextEditingController _pController = TextEditingController();
  TextEditingController _kController = TextEditingController();
  TextEditingController _phController = TextEditingController();
  TextEditingController _rainfallController = TextEditingController();
  String temperature = '';
  String humidity = '';
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
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$latitude,$longitude';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Map<String, dynamic> currentData = data['current'];
        print(currentData);
        print(currentData['temp_c'].runtimeType);
        final String temp = currentData['temp_c'].toString();
        final String hum = currentData['humidity'].toString();
        print("$temp $hum");
        temperature = temp;
        humidity = hum;
        setState(() {});
        // return {'temperature': temperature, 'humidity': humidity};
      } else {
        throw Exception(
            'Failed to load weather data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching weather data: $error');
    }
  }

  Future<void> _predictCrop() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (temperature.isEmpty || humidity.isEmpty) {
      print('Temperature and humidity cannot be empty.');
      return;
    }
    double? tempValue = double.tryParse(temperature);
    double? humidityValue = double.tryParse(humidity);
    if (tempValue == null || humidityValue == null) {
      print('Invalid temperature or humidity value.');
      return;
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
      print("${latitude!.toStringAsFixed(3)}   ${longitude!.toStringAsFixed(3)}");
      getWeatherData(latitude!.toStringAsFixed(3), longitude!.toStringAsFixed(3));
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
          // Container(width: double.infinity,
          //   child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       if (_currentPosition != null)
          //         Text(
          //             "LAT: ${_currentPosition!.latitude}, LNG: ${_currentPosition!.longitude}"),
          //       SizedBox(
          //         height: 20,
          //       ),
          //       ElevatedButton(
          //         child: Text("Get location"),
          //         onPressed: () {
          //           _checkLocationPermission();
          //         },
          //       ),
          //     ],
          //   ),
          // ),
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
                          onPressed:(){
                            _predictCrop();
                          } ,
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
