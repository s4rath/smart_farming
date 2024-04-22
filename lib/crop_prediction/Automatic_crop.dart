import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:smart_farming/crop_prediction/crop_details.dart';
import 'package:smart_farming/crop_prediction/crop_prediction_model.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as gc;

class CropPredictionAuto extends StatefulWidget {
  const CropPredictionAuto({super.key});

  @override
  State<CropPredictionAuto> createState() => _CropPredictionAutoState();
}

class _CropPredictionAutoState extends State<CropPredictionAuto>
    with WidgetsBindingObserver {
  Position? _currentPosition;
  LocationData? _location;
  double? latitude;
  double? longitude;
  final formKey = GlobalKey<FormState>();
  String predictedCrop = "";
  String dewPoint = "";
  List<dynamic> top5Crops = [];
  TextEditingController _nController = TextEditingController();
  TextEditingController _pController = TextEditingController();
  TextEditingController _kController = TextEditingController();
  TextEditingController _phController = TextEditingController();
  TextEditingController _rainfallController = TextEditingController();
  String temperature = '';
  String humidity = '';
  String districtName = '';
  String stateName = '';
  double rainfall = 0;
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
        final Map<String, dynamic> forecastData =
            data['forecast']['forecastday'][0]['hour'][0];
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
        "rainfall": rainfall,
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

  _getCurrentLocation() async {
    Location location = Location();
    try {
      final locationResult = await location.getLocation();
      setState(() {
        _location = locationResult;
        latitude = _location!.latitude;
        longitude = _location!.longitude;
      });
    } catch (e) {}

    getWeatherData(latitude!.toStringAsFixed(3), longitude!.toStringAsFixed(3));
    print("${latitude!.toStringAsFixed(3)}   ${longitude!.toStringAsFixed(3)}");
    // List<gc.Placemark> placemarks = await  gc.placemarkFromCoordinates(double.parse(latitude!.toStringAsFixed(3)), double.parse(longitude!.toStringAsFixed(3)));
    // print(placemarks);
    _fetchStateAndDistrict(double.parse(latitude!.toStringAsFixed(3)),
        double.parse(longitude!.toStringAsFixed(3)));
    getRainfallForDistrict(districtName);
  }

  Future<void> _fetchStateAndDistrict(double latitude, double longitude) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var resBody = jsonDecode(json.encoder.convert(response.body));
        print(resBody);
        final jsonData = json.decode(response.body);
        final state = jsonData['address']['state'];
        final district = jsonData['address']['state_district'] ??
            jsonData['address']['city_district'] ??
            jsonData['address']['village'] ??
            jsonData['address']['county'] ??
            jsonData['address']['city'];

        setState(() {
          districtName = district.split(' ')[0];
          stateName = state;
        });
        print(districtName);
        print(stateName);
      } else {
        throw Exception('Failed to fetch location data');
      }
    } catch (e) {
      print('Error fetching location data: $e');
    }
  }

  Future<void> getRainfallForDistrict(String districtName) async {
    // API endpoint URL
    final url = 'http://johnhona1.pythonanywhere.com/rainfall_sheet';

    // Request payload
    final Map<String, dynamic> payload = {
      'district':
          districtName.toUpperCase(), // Convert district name to uppercase
    };

    try {
      // Send POST request to the API
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(payload),
        headers: {'Content-Type': 'application/json'},
      );

      // Check if request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse JSON response
        final data = json.decode(response.body);
        final matchedDistrict = data['matched_district'];
        rainfall = data['rainfall'];
        print("rainfall : $rainfall");
        setState(() {
          _rainfallController.text = rainfall.toString();
        });
        // return {'matched_district': matchedDistrict, 'rainfall': rainfall};
      } else {
        print('Error: Request failed with status code ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Crop Prediction Automatic",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 58, 143, 188),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        elevation: 0,
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
                    image: AssetImage('assets/images/wp1886339.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Center(
                child: Container(
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, right: 8, left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5), // Add some top padding
                          child: Text(
                            'Crop Prediction by Soil Conditions', // Add the heading text here
                            textAlign: TextAlign
                                .center, // Aligns the text horizontally within the container
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.5, // Adjust the font size as needed
                              // Adjust the font weight as needed
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
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
                                    return "Value between 0 and 140";
                                  }
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Nitrogen',
                                hintText: '',
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                  borderSide:
                                      new BorderSide(color: Colors.green),
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
                                    return "Value between 0 and 145";
                                  }
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Phosphorous',
                                hintText: '',
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                  borderSide:
                                      new BorderSide(color: Colors.green),
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
                                    return "Value between 0 and 205";
                                  }
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Potassium',
                                hintText: '',
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                  borderSide:
                                      new BorderSide(color: Colors.green),
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
                              decoration: InputDecoration(
                                labelText: 'pH',
                                hintText: '',
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                  borderSide:
                                      new BorderSide(color: Colors.green),
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
                              // decoration: InputDecoration(),
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
                              style: TextStyle(color: Colors.black),
                              enabled: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter a Value";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                labelText: 'Rainfall',
                                hintText: '',
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                  borderSide:
                                      new BorderSide(color: Colors.green),
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
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            final prediction = await _predictCrop();
                            cropPrediction = prediction!;
                            predictedCrop = prediction.predictedCrop;
                            top5Crops = prediction.top5Crops;
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 50),
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
                                top: 10, left: 20, right: 20, bottom: 10),
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
