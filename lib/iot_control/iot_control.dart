import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class IoTControlPage extends StatefulWidget {
  @override
  _IoTControlPageState createState() => _IoTControlPageState();
}

class _IoTControlPageState extends State<IoTControlPage> {
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
  bool _isUserControl = false;
  bool _isUserControl1 = false;
  final DBref = FirebaseDatabase.instance.reference();
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();

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
    bool _isUserFanControlled = false;
  }

  void dispose() {
    _timerController4.dispose();
    _pauseTimer4?.cancel();
    _timerController1.dispose();
    _pauseTimer1?.cancel();
    _timerController2.dispose();
    _pauseTimer2?.cancel();
    _timerController3.dispose();
    _pauseTimer3?.cancel();

    /// Cancel the timer to avoid memory leaks
    super.dispose();
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

    setState(() {
      isLoading = false;
    });
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

    _countdownTimer1 = Timer.periodic(Duration(seconds: 1), (timer) {
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

        // Cancel the countdown timer
        _countdownTimer1.cancel();
      }
    });

    // Your existing button functionality here
    // For example, toggle FAN_STATUS immediately when the button is pressed
    if (fanStatus == 0) {
      DBref.child('FAN_STATUS').set(1);
      setState(() {
        fanStatus = 1;
      });
    } else {
      DBref.child('FAN_STATUS').set(0);
      setState(() {
        fanStatus = 0;
      });
    }
  }

  Future<void> _checkClimateValue() async {
    // Check if the user is not currently controlling the fan manually
    if (!_isUserControl &&
        (int.tryParse(temperatureValue) != null &&
                int.parse(temperatureValue) > 35 ||
            int.tryParse(HumidityValue) != null &&
                int.parse(HumidityValue) > 60 ||
            int.tryParse(smokeValue) != null && int.parse(smokeValue) > 150)) {
      // Trigger the fan to ON state
      await DBref.child('FAN_STATUS').set(1);
      setState(() {
        fanStatus = 1;
      });
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

    setState(() {
      isLoading1 = false;
    });
  }

  void _startTimer2() {
    int timerSeconds2 = int.tryParse(_timerController2.text) ?? 20;

    setState(() {
      _isLdrCheckPaused = true;
      _timerDuration2 = timerSeconds2;
    });

    _countdownTimer2 = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timerDuration2--;
      });

      if (_timerDuration2 == 0) {
        setState(() {
          _isLdrCheckPaused = false;
        });
        _countdownTimer2.cancel();
      }
    });

    // Toggle LED_STATUS immediately when the button is pressed
    setState(() {
      ledStatus = (ledStatus == 0) ? 1 : 0;
    });
    DBref.child('LED_STATUS').set(ledStatus);
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
    if (!_isLdrCheckPaused &&
        int.tryParse(ldrValue) != null &&
        int.parse(ldrValue) < 600) {
      await DBref.child('LED_STATUS').set(1);
      setState(() {
        ledStatus = 1;
      });
    }
    //changed
    if (!_isLdrCheckPaused &&
        int.tryParse(ldrValue) != null &&
        int.parse(ldrValue) > 600) {
      await DBref.child('LED_STATUS').set(0);
      setState(() {
        ledStatus = 0;
      });
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
    int timerSeconds3 = int.tryParse(_timerController1.text) ?? 20;

    setState(() {
      _isSoilCheckPaused = true;
      _timerDuration3 = timerSeconds3;
    });

    _countdownTimer3 = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timerDuration3--;
      });

      if (_timerDuration3 == 0) {
        // Resume automatic checking after specified seconds
        setState(() {
          _isSoilCheckPaused = false;
        });

        // Cancel the countdown timer
        _countdownTimer3.cancel();
      }
    });

    // Update PumpStatus and PUMP_STATUS together
    if (PumpStatus == 0) {
      setState(() {
        PumpStatus = 1;
        DBref.child('PUMP_STATUS').set(1);
      });
    } else {
      setState(() {
        PumpStatus = 0;
        DBref.child('PUMP_STATUS').set(0);
      });
    }
  }

  Future<void> _checkSoilValue() async {
    if (!_isSoilCheckPaused &&
        int.tryParse(soilMoistureValue) != null &&
        int.parse(soilMoistureValue) > 600) {
      await DBref.child('PUMP_STATUS').set(1);

      setState(() {
        PumpStatus = 1;
      });
    }
    if (!_isSoilCheckPaused &&
        int.tryParse(soilMoistureValue) != null &&
        int.parse(soilMoistureValue) < 600) {
      await DBref.child('PUMP_STATUS').set(0);

      setState(() {
        PumpStatus = 0;
      });
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

    setState(() {
      isLoading3 = false;
    });
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

    _countdownTimer4 = Timer.periodic(Duration(seconds: 1), (timer) {
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

        // Cancel the countdown timer
        _countdownTimer4.cancel();
      }
    });

    // Your existing button functionality here
    // For example, toggle FAN_STATUS immediately when the button is pressed
    WindowStatus == 0
        ? DBref.child('WINDOW_STATUS').set(1)
        : DBref.child('WINDOW_STATUS').set(0);

    setState(() {
      if (WindowStatus == 0) {
        WindowStatus = 1;
        DBref.child('WINDOW_STATUS').set(1);
      } else {
        WindowStatus = 0;
        DBref.child('WINDOW_STATUS').set(0);
      }
    });
  }

  Future<void> _checkEnvironmentValue() async {
    // Check if the user is not currently controlling the fan manually
    if (!_isUserControl1 &&
        (int.tryParse(temperatureValue) != null &&
                int.parse(temperatureValue) > 35 ||
            int.tryParse(HumidityValue) != null &&
                int.parse(HumidityValue) > 60 ||
            int.tryParse(smokeValue) != null && int.parse(smokeValue) > 150)) {
      // Trigger the fan to ON state
      await DBref.child('WINDOW_STATUS').set(1);
      setState(() {
        WindowStatus = 1;
      });
    }
    //changed
    //   if (!_isUserControl1 &&
    //     (int.tryParse(temperatureValue) != null &&
    //             int.parse(temperatureValue) < 35 ||
    //         int.tryParse(HumidityValue) != null &&
    //             int.parse(HumidityValue) < 60 ||
    //         int.tryParse(smokeValue) != null && int.parse(smokeValue) < 150)) {
    //   // Trigger the fan to ON state
    //   await DBref.child('WINDOW_STATUS').set(0);
    //   setState(() {
    //     WindowStatus = 0;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
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
        // print("ldrvlaue: $soilMoistureValue");
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IoT Control',
          style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.deepPurple,
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
                    'assets/images/iotback.jpg',
                    // Replace with your background image path
                    fit: BoxFit.cover,
                  ),
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
                                      fontSize: 20,
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
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Soil Moisture: ${soilMoistureValue}ADC',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Smoke: ${smokeValue}ppm',
                                          style: TextStyle(
                                            fontSize: 16,
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
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Humidity: $HumidityValue%RH',
                                          style: TextStyle(
                                            fontSize: 16,
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
