import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:smart_farming/crop_prediction/crop_details.dart';
import 'package:smart_farming/crop_prediction/crop_prediction_model.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class CropAutomaticClimate extends StatefulWidget {
  const CropAutomaticClimate({super.key});

  @override
  State<CropAutomaticClimate> createState() => _CropPredictionAutoState();
}

class _CropPredictionAutoState extends State<CropAutomaticClimate>
    with WidgetsBindingObserver {
  LocationData? _location;
  double? latitude;
  double? longitude;
  final formKey = GlobalKey<FormState>();
  String predictedCrop = "";
  String dewPoint = "";
  List<dynamic> top5Crops = [];
  TextEditingController _rainfallController = TextEditingController();
  String temperature = '';
  String humidity = '';
  late CropPrediction cropPrediction;
  String districtName = '';
  String stateName = '';
  double rainfall = 0;
  bool isLoading = true;
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
    final apiUrl = 'http://johnhona1.pythonanywhere.com/automatepredict';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "temperature": tempValue,
        "humidity": humidityValue,
        "rainfall": rainfall,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      return CropPrediction.fromJson(data);
    } else {
      print('Failed to make prediction. Status code: ${response.statusCode}');
    }
    return null;
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    Location location = Location();

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
    setState(() {
      isLoading = true;
    });
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
    setState(() {
      isLoading = true;
    });

    final url = 'http://johnhona1.pythonanywhere.com/rainfall_sheet';

    final Map<String, dynamic> payload = {
      'district': districtName.toUpperCase(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(payload),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final matchedDistrict = data['matched_district'];
        rainfall = data['rainfall'];
        print("rainfall : $rainfall");
        setState(() {
          _rainfallController.text = rainfall.toString();
          isLoading = false;
        });
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
                child: isLoading
                    ? CircularProgressIndicator()
                    : Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 20, right: 8, left: 8),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  'Crop Prediction by Climatic Conditions',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.5,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
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
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      labelText: 'Rainfall',
                                      hintText: '',
                                      hintStyle: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
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
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.green),
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 10),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
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
                                onPressed: () async {
                                  final prediction = await _predictCrop();
                                  cropPrediction = prediction!;
                                  predictedCrop = prediction.predictedCrop;
                                  top5Crops = prediction.top5Crops;
                                  setState(() {});
                                },
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
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.green),
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
                                                    predictedCrop:
                                                        predictedCrop,
                                                    top5crops: top5Crops,
                                                    cropPrediction:
                                                        cropPrediction,
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
                                        style: GoogleFonts.getFont(
                                            'Didact Gothic',
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
