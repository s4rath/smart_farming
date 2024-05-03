import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';


class IoTControlPage extends StatefulWidget {
  @override
  _IoTControlPageState createState() => _IoTControlPageState();
}

class _IoTControlPageState extends State<IoTControlPage>
    with WidgetsBindingObserver {
  double displayHum = 0.0;
  String ldrValue = '';
  String soilMoistureValue = '';
  String temperatureValue = '';
  String HumidityValue = '';
  String smokeValue = '';
  Timer? timer;
  int _timerDuration4 = 0;
  late Timer _countdownTimer4;
  bool _isLdrCheckPaused = false;
  int _timerDuration1 = 0;
  late Timer _countdownTimer1;
  bool _isSoilCheckPaused = false;
  int _timerDuration2 = 0;
  late Timer _countdownTimer2;
  bool _isClimateCheckPaused = false;
  int _timerDuration3 = 0;
  late Timer _countdownTimer3;
  bool _isEnvironmentCheckPaused = false;
  TextEditingController _timerController3 = TextEditingController();
  TextEditingController _timerController4 = TextEditingController();
  TextEditingController _timerController1 = TextEditingController();
  TextEditingController _timerController2 = TextEditingController();
  Timer? _pauseTimer4;
  Timer? _pauseTimer2;
  Timer? _pauseTimer1;
  Timer? _pauseTimer3;
  int ledStatus = 0;
  int fanStatus = 0;
  int PumpStatus = 0;
  int WindowStatus = 0;
  bool isLoading = false;
  bool isLoading1 = false;
  bool isLoading2 = false;
  bool isLoading3 = false;
  bool isLoading4 = false;
  bool _isUserControl = false;
  bool _isUserControl1 = false;
  final DBref = FirebaseDatabase.instance.reference();
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();
  double relativeHumidity = 0.0;
  String dewPoint = '';
  String Humidity = '';
  // Position? _currentPosition;
   LocationData? _location;
  double? latitude;
  double? longitude;
  DatabaseReference ldrReference =
        FirebaseDatabase.instance.ref().child("Light").child("Ldr_Value");
    DatabaseReference soilReference =
        FirebaseDatabase.instance.ref().child("Soil").child("Soil_Moisture");
    DatabaseReference TemperatureReference = FirebaseDatabase.instance
        .ref()
        .child("Temperature")
        .child("Celsius_Value");
    DatabaseReference SmokeReference =
        FirebaseDatabase.instance.ref().child("Smoke").child("PPM_Value");
    DatabaseReference HumidityReference = FirebaseDatabase.instance
        .ref()
        .child("Humidity")
        .child("Percentage_Value");

  @override
  void initState() {
    super.initState();
    isLoading = true;
    isLoading1 = true;
    isLoading2 = true;
    getPUMPStatus();
    getFANStatus();
    getLEDStatus();
    getWINDOWStatus();
    tz.initializeTimeZones();
    bool _isUserFanControlled = false;
    WidgetsBinding.instance.addObserver(this);
    _checkLocationPermission();
    _startfirebaselisteners();
  }

  @override
void dispose() {
  // Cancel all timers
  _countdownTimer1.cancel();
  _countdownTimer2.cancel();
  _countdownTimer3.cancel();
  _countdownTimer4.cancel();
  // Dispose of controllers
  _timerController1.dispose();
  _timerController2.dispose();
  _timerController3.dispose();
  _timerController4.dispose();
  ldrReference.onValue.listen(null);
  soilReference.onValue.listen(null);
  TemperatureReference.onValue.listen(null);
  HumidityReference.onValue.listen(null);
  SmokeReference.onValue.listen(null);
  // Remove observer
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
        final Map<String, dynamic> forecastData =
            data['forecast']['forecastday'][0]['hour'][0];
        final String dewpoint_c = forecastData['dewpoint_c'].toString();
        setState(() {
          dewPoint = dewpoint_c;
          print(dewPoint);
        });

        setState(() {
          relativeHumidity = 100 -
              5 * (double.parse(temperatureValue) - double.parse(dewPoint));
          Humidity = relativeHumidity.toString();
        });
      } else {
        throw Exception(
            'Failed to load weather data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching weather data: $error');
    }
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
    Location location = Location();
      try {
      final locationResult = await location.getLocation();
       setState(() {
    _location = locationResult;
    latitude = _location!.latitude;
    longitude = _location!.longitude;
  });
     
    } on PlatformException catch (err) {
    print(err);
    }
  getWeatherData(
          latitude!.toStringAsFixed(3), longitude!.toStringAsFixed(3));
      print(
          "${latitude!.toStringAsFixed(3)}   ${longitude!.toStringAsFixed(3)}");
  }

//Fan Control begins here
  Future<void> getFANStatus() async {
    await DBref.child('FAN_STATUS').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      dynamic value = snapshot.value;

      // Check if the value is not null before assigning
      if (value != null) {
        setState(() {
          fanStatus = value as int;
        });
        print(fanStatus);
      } else {
        // Handle the case where the value is null or not of type int
        print('Invalid value received: $value');
      }
    });
    if (mounted) {
  setState(() {
    isLoading = false;
  });
}
  }

  void button1Pressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Timer Duration (seconds)'),
          content: TextField(
            controller: _timerController1,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _startTimer1();
              },
              child: Text('Set'),
            ),
          ],
        );
      },
    );
  }

  void _startTimer1() {
    // Pause automatic checking based on user input seconds
    int timerSeconds1 = int.tryParse(_timerController1.text) ?? 20;
    setState(() {
      _isClimateCheckPaused = true;
      _isUserControl = true; // Set to true when user manually controls the fan
      _timerDuration1 = timerSeconds1;
    });
    _countdownTimer1 = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {
        _timerDuration1--;
      });
      if (_timerDuration1 == 0) {
        // Resume automatic checking after specified seconds
        setState(() {
          _isClimateCheckPaused = false;
          _isUserControl =
              false; // Reset to false when user-controlled time is over
        });
        // Get the latest status of the fan
        print("checking fan status::::::");
        await _checkClimateValue();
        getFANStatus();
        // Cancel the countdown timer
        _countdownTimer1.cancel();
      }
    });
    // Your existing button functionality here
    // For example, toggle FAN_STATUS immediately when the button is pressed
    if (fanStatus == 0) {
      DBref.child('FAN_STATUS').set(1);
      if (mounted) {
  setState(() {
    fanStatus = 1;
  });
}
    } else {
      DBref.child('FAN_STATUS').set(0);
      if (mounted) {
  setState(() {
    fanStatus = 0;
  });
}
    }
  }
  void _startfirebaselisteners(){
    ldrReference.onValue.listen((DatabaseEvent event) {
      setState(() {
        ldrValue = event.snapshot.value.toString();
      });
      _checkLdrValue();
      _checkEnvironmentValue();
    });
    soilReference.onValue.listen((DatabaseEvent event) {
      setState(() {
        soilMoistureValue = event.snapshot.value.toString();
      });
      _checkSoilValue();
    });
    TemperatureReference.onValue.listen((DatabaseEvent event) {
      setState(() {
        temperatureValue = event.snapshot.value.toString();
      });
      _checkClimateValue();
      _checkEnvironmentValue();
    });
    HumidityReference.onValue.listen((DatabaseEvent event) {
      setState(() {
        HumidityValue = event.snapshot.value.toString();
      });
      _checkClimateValue();
      _checkEnvironmentValue();
    });
    SmokeReference.onValue.listen((DatabaseEvent event) {
      setState(() {
        smokeValue = event.snapshot.value.toString();
      });
      _checkClimateValue();
      _checkEnvironmentValue();
    });
  }

  Future<void> _checkClimateValue() async {
    // Check if the user is not currently controlling the fan manually
    if (!_isUserControl &&
        (double.tryParse(temperatureValue) != null &&
                double.parse(temperatureValue) > 35.0 ||
            double.tryParse(Humidity) != null &&
                double.parse(Humidity) > 60.0 ||
            int.tryParse(smokeValue) != null && int.parse(smokeValue) > 150)) {        // +++++++++++++++++++++fan
      // Trigger the fan to ON state
      await DBref.child('FAN_STATUS').set(1);
      print("checking climate value...." );
      if (mounted) {
  setState(() {
    fanStatus = 1;
  });
}
    } else {
      if (!_isUserControl) {
        await DBref.child('FAN_STATUS').set(0);
        if (mounted) {
  setState(() {
    fanStatus = 0;
  });
}
      } else {
        // Get the latest status of the fan
        getFANStatus();
      }
    }
  }

//Fan Control Ends Here
//Light Control begins here
  Future<void> getLEDStatus() async {
    await DBref.child('LED_STATUS').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      dynamic value = snapshot.value;
      // Check if the value is not null before assigning
      if (value != null) {
        setState(() {
          ledStatus = value as int;
        });
        print(ledStatus);
      } else {
        // Handle the case where the value is null or not of type int
        print('Invalid value received: $value');
      }
    });

    if (mounted) {
  setState(() {
    isLoading1 = false;
  });
}
  }

  void _startTimer2() {
    // Pause automatic checking based on user input seconds
    int timerSeconds2 = int.tryParse(_timerController2.text) ?? 20;
    setState(() {
      _isLdrCheckPaused = true;
      _timerDuration2 = timerSeconds2;
    });

    _countdownTimer2 = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {
        _timerDuration2--;
      });
      if (_timerDuration2 == 0) {
        // Resume automatic checking after specified seconds
        setState(() {
          _isLdrCheckPaused = false;
        });
        // Cancel the countdown timer
        await _checkLdrValue();
        getLEDStatus();
        _countdownTimer2.cancel();
      }
    });
    // Your existing button functionality here
    // For example, toggle LED_STATUS immediately when the button is pressed
    if (ledStatus == 0) {
      DBref.child('LED_STATUS').set(1);
      if (mounted) {
  setState(() {
    ledStatus = 1;
  });
}
    } else {
      DBref.child('LED_STATUS').set(0);
      if (mounted) {
  setState(() {
    ledStatus = 0;
  });
}
    }
  }

  void button2Pressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Timer Duration (seconds)'),
          content: TextField(
            controller: _timerController2,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _startTimer2();
              },
              child: Text('Set'),
            ),
          ],
        );
      },
    );
  }

  // Toggle LED_STATUS immediately when the button is pressed
  Future<void> _checkLdrValue() async {
    // Get the current Indian time
    tz.Location ist = tz.getLocation('Asia/Kolkata');
    tz.TZDateTime currentTime = tz.TZDateTime.now(ist);
    // Format the current time to get only the hour component
    int currentHour = currentTime.hour;
    // Check if the current time is between 10 AM and 4 PM
    if (!_isLdrCheckPaused &&
        currentHour >= 10 &&
        currentHour < 16 &&
        int.tryParse(ldrValue) != null &&
        int.parse(ldrValue) < 600) {
      await DBref.child('LED_STATUS').set(1);
      if (mounted) {
  setState(() {
    ledStatus = 1;
  });
}
    } else {
      if (!_isLdrCheckPaused) {
        await DBref.child('LED_STATUS').set(0);
        if (mounted) {
          setState(() {
            ledStatus = 0;
          });
        }
      } else {
        getLEDStatus();
      }
    }
  }

// Light control ends here
  //Irrigation Control begins here
  Future<void> getPUMPStatus() async {
    await DBref.child('PUMP_STATUS').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      dynamic value = snapshot.value;
      // Check if the value is not null before assigning
      if (value != null) {
        setState(() {
          PumpStatus = value as int;
        });
        print(PumpStatus);
      } else {
        // Handle the case where the value is null or not of type int
        print('Invalid value received: $value');
      }
    });
    setState(() {
      isLoading2 = false;
    });
  }

  void button3Pressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Timer Duration (seconds)'),
          content: TextField(
            controller: _timerController3,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _startTimer3();
              },
              child: Text('Set'),
            ),
          ],
        );
      },
    );
  }

  void _startTimer3() {
    // Pause automatic checking based on user input seconds
    int timerSeconds3 = int.tryParse(_timerController3.text) ?? 20;
    setState(() {
      _isSoilCheckPaused = true;
      _timerDuration3 = timerSeconds3;
    });
    _countdownTimer3 = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {
        _timerDuration3--;
      });
      if (_timerDuration3 == 0) {
        // Resume automatic checking after specified seconds
        setState(() {
          _isSoilCheckPaused = false;
        });
        await _checkSoilValue();
        getPUMPStatus();
        // Cancel the countdown timer
        _countdownTimer3.cancel();
      }
      
    });
    print("helloooo");
    // Update PumpStatus and PUMP_STATUS together
    if (PumpStatus == 0) {
      DBref.child('PUMP_STATUS').set(1);
      if (mounted) {
  setState(() {
    PumpStatus = 1;
  });
}
    } else {
      DBref.child('PUMP_STATUS').set(0);
      if (mounted) {
  setState(() {
    PumpStatus = 0;
  });
}
    }
  }

  Future<void> _checkSoilValue() async {
    if (!_isSoilCheckPaused &&
        int.tryParse(soilMoistureValue) != null &&
        int.parse(soilMoistureValue) > 600) { //+++++++++++++++++++++++ pump
      await DBref.child('PUMP_STATUS').set(1);

      if (mounted) {
  setState(() {
    PumpStatus = 1;
  });
}
    } else {
      if (!_isSoilCheckPaused) {
        await DBref.child('PUMP_STATUS').set(0);
        if (mounted) {
  setState(() {
    PumpStatus = 0;
  });
}
      } else {
        getPUMPStatus();
      }
    }
  }

  //Irrigation Control ends here
  Future<void> getWINDOWStatus() async {
    await DBref.child('WINDOW_STATUS').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      dynamic value = snapshot.value;

      // Check if the value is not null before assigning
      if (value != null) {
        setState(() {
          WindowStatus = value as int;
        });
        print(WindowStatus);
      } else {
        // Handle the case where the value is null or not of type int
        print('Invalid value received: $value');
      }
    });
    if (mounted) {
  setState(() {
    isLoading3 = false;
  });
}
  }

  void button4Pressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Timer Duration (seconds)'),
          content: TextField(
            controller: _timerController4,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _startTimer4();
              },
              child: Text('Set'),
            ),
          ],
        );
      },
    );
  }

  void _startTimer4() {
    // Pause automatic checking based on user input seconds
    int timerSeconds4 = int.tryParse(_timerController4.text) ?? 20;
    setState(() {
      _isEnvironmentCheckPaused = true;
      _isUserControl1 = true; // Set to true when user manually controls the fan
      _timerDuration4 = timerSeconds4;
    });
    _countdownTimer4 = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {
        _timerDuration4--;
      });

      if (_timerDuration4 == 0) {
        // Resume automatic checking after specified seconds
        setState(() {
          _isEnvironmentCheckPaused = false;
          _isUserControl1 =
              false; // Reset to false when user-controlled time is over
        });
        await _checkEnvironmentValue();
        getWINDOWStatus();
        // Cancel the countdown timer
        _countdownTimer4.cancel();
      }
    });
    // Your existing button functionality here
    // For example, toggle FAN_STATUS immediately when the button is pressed
    if (WindowStatus == 0) {
      DBref.child('WINDOW_STATUS').set(1);
      if (mounted) {
  setState(() {
    WindowStatus = 1;
  });
}
    } else {
      DBref.child('WINDOW_STATUS').set(0);
      if (mounted) {
  setState(() {
    WindowStatus = 0;
  });
}
    }
  }

  Future<void> _checkEnvironmentValue() async {
    // Check if the user is not currently controlling the fan manually
    if (!_isUserControl1 &&
        (double.tryParse(temperatureValue) != null &&
                double.parse(temperatureValue) > 40.0 ||
            double.tryParse(Humidity) != null &&
                double.parse(Humidity) > 60.0 ||
            int.tryParse(smokeValue) != null && int.parse(smokeValue) > 150)) {  //++++++++++++++++ window
      // Trigger the fan to ON state
      await DBref.child('WINDOW_STATUS').set(1);
      if (mounted) {
  setState(() {
    WindowStatus = 1;
  });
}
    } else {
      if (!_isUserControl1) {
        await DBref.child('WINDOW_STATUS').set(0);
        
        if (mounted) {
  setState(() {
    WindowStatus = 0;
  });
}
      } else {
        getWINDOWStatus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Greenhouse Control',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black.withOpacity(1),
      ),
      body: FutureBuilder(
        future: _fApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something wrong with firebase");
          } else if (snapshot.hasData) {
            return Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/download.jfif',
                    // Replace with your background image path
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.1), // Lower opacity
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.green[300]?.withOpacity(0.3),
                          padding: EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    'Sensor Monitor',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Light Intensity:  ${ldrValue}nm',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Soil Moisture: ${soilMoistureValue}ADC',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Smoke: ${smokeValue}ppm',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Temperature: $temperatureValue°C',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Humidity: ${Humidity}%RH',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                button1Pressed();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      fanStatus == 0
                                          ? 'Turn Fan On'
                                          : 'Turn Fan Off',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Image.asset(
                                      fanStatus == 0
                                          ? 'assets/images/fanoff.png'
                                          : 'assets/images/fanon.gif',
                                      width: 80,
                                      height: 110,
                                    ),
                                    if (_isClimateCheckPaused)
                                      Text(
                                        'Countdown: \n$_timerDuration1 seconds',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                button2Pressed();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      ledStatus == 0
                                          ? 'Turn Light On'
                                          : 'Turn Light Off',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Image.asset(
                                      ledStatus == 0
                                          ? 'assets/images/bulboff.png'
                                          : 'assets/images/bulbon.png',
                                      width: 80,
                                      height: 110,
                                    ),
                                    if (_isLdrCheckPaused)
                                      Text(
                                        'Countdown: \n$_timerDuration2 seconds',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                button3Pressed();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      PumpStatus == 0
                                          ? 'Start Watering'
                                          : 'Stop Watering',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Image.asset(
                                      PumpStatus == 0
                                          ? 'assets/images/pumpoff.png'
                                          : 'assets/images/pumpon.png',
                                      width: 80,
                                      height: 150,
                                    ),
                                    if (_isSoilCheckPaused)
                                      Text(
                                        'Countdown: \n$_timerDuration3 seconds',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                button4Pressed();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      WindowStatus == 0
                                          ? 'Open Windows'
                                          : 'Shut Windows',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Image.asset(
                                      WindowStatus == 0
                                          ? 'assets/images/windowclose.png'
                                          : 'assets/images/windowopen.png',
                                      width: 80,
                                      height: 150,
                                    ),
                                    if (_isEnvironmentCheckPaused)
                                      Text(
                                        'Countdown: \n$_timerDuration4 seconds',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
