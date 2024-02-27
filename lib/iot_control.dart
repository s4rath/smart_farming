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
  int ledStatus = 0;
  int fanStatus = 0;
  int PumpStatus = 0;
  int WindowStatus = 0;
  bool isLoading = false;
  bool isLoading1 = false;
  bool isLoading2 = false;
  bool isLoading3 = false;
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
  }

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

  void buttonPressed() {
    fanStatus == 0
        ? DBref.child('FAN_STATUS').set(1)
        : DBref.child('FAN_STATUS').set(0);
    if (fanStatus == 0) {
      setState(() {
        fanStatus = 1;
      });
    } else {
      setState(() {
        fanStatus = 0;
      });
    }
  }

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

  void button1Pressed() {
    ledStatus == 0
        ? DBref.child('LED_STATUS').set(1)
        : DBref.child('LED_STATUS').set(0);
    if (ledStatus == 0) {
      setState(() {
        ledStatus = 1;
      });
    } else {
      setState(() {
        ledStatus = 0;
      });
    }
  }

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

  void button2Pressed() {
    PumpStatus == 0
        ? DBref.child('PUMP_STATUS').set(1)
        : DBref.child('PUMP_STATUS').set(0);
    if (PumpStatus == 0) {
      setState(() {
        PumpStatus = 1;
      });
    } else {
      setState(() {
        PumpStatus = 0;
      });
    }
  }

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

  void button3Pressed() {
    WindowStatus == 0
        ? DBref.child('WINDOW_STATUS').set(1)
        : DBref.child('WINDOW_STATUS').set(0);
    if (WindowStatus == 0) {
      setState(() {
        WindowStatus = 1;
      });
    } else {
      setState(() {
        WindowStatus = 0;
      });
    }
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
    });

    soilReference.onValue.listen((DatabaseEvent event) {
      setState(() {
        soilMoistureValue = event.snapshot.value.toString();
      });
    });
    TemperatureReference.onValue.listen((DatabaseEvent event) {
      setState(() {
        temperatureValue = event.snapshot.value.toString();
      });
    });
    HumidityReference.onValue.listen((DatabaseEvent event) {
      setState(() {
        HumidityValue = event.snapshot.value.toString();
      });
    });
    SmokeReference.onValue.listen((DatabaseEvent event) {
      setState(() {
        smokeValue = event.snapshot.value.toString();
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IoT Control',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: FutureBuilder(
        future: _fApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something wrong with firebase");
          } else if (snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LDR Value: $ldrValue',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Soil Moisture Value: $soilMoistureValue',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Temperature Value: $temperatureValue',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Humidity Value: $HumidityValue',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Smoke Value: $smokeValue',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      buttonPressed();
                    },
                    child: Text(
                      fanStatus == 0 ? 'Turn Fan On' : 'Turn Fan Off',
                      style: GoogleFonts.getFont('Didact Gothic',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      button1Pressed();
                    },
                    child: Text(
                      ledStatus == 0 ? 'Turn Light On' : 'Turn Light Off',
                      style: GoogleFonts.getFont('Didact Gothic',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      button2Pressed();
                    },
                    child: Text(
                      PumpStatus == 0
                          ? 'Turn Water Pump On'
                          : 'Turn Water Pump Off',
                      style: GoogleFonts.getFont('Didact Gothic',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      button3Pressed();
                    },
                    child: Text(
                      WindowStatus == 0 ? 'Slide Window' : 'Shut Windows',
                      style: GoogleFonts.getFont('Didact Gothic',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
