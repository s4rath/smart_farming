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
  // late var timerr;
  final DBref = FirebaseDatabase.instance.reference();
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      isLoading = true;
      isLoading1 = true;
      isLoading2 = true;
      getPUMPStatus();
      getFANStatus();
      // getLEDStatus();
      getWINDOWStatus();
      // checkLdrValueAndToggleLed();

      // timerr = Timer.periodic(
      //     Duration(seconds: 60), (Timer t) => setState(() {}));
    }
  }

  @override
  void dispose() {
    // timerr.cancel();
    super.dispose();
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

  // Future<void> getLEDStatus() async {
  //   await DBref.child('LED_STATUS').once().then((DatabaseEvent event) {
  //     DataSnapshot snapshot = event.snapshot;
  //     dynamic value = snapshot.value;

  //     // Check if the value is not null before assigning
    //   if (value != null) {
    //     setState(() {
    //       ledStatus = value as int;
    //     });
    //     print("ledstatus: $ledStatus");
    //   } else {
    //     // Handle the case where the value is null or not of type int
    //     print('Invalid value received: $value');
    //   }
    // });

  //   setState(() {
  //     isLoading1 = false;
  //   });
  // }

  Future<void> getPUMPStatus() async {
    await DBref.child('PUMP_STATUS').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      dynamic value = snapshot.value;

      // Check if the value is not null before assigning
      if (value != null) {
        setState(() {
          PumpStatus = value as int;
        });
        print("Pumpstatus: $PumpStatus");
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
        print("Window status: $WindowStatus");
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

  void checkLdrValueAndToggleLed() {
    DatabaseReference ldrReference =
        FirebaseDatabase.instance.ref().child("Light").child("Ldr_Value");

    ldrReference.once().then((DatabaseEvent event) {
      // Assuming the data is stored as an integer
      DataSnapshot snapshot = event.snapshot;
      dynamic ldrValue = snapshot.value;

      // Check if the value is less than 600
      if (ldrValue < 600) {
        // Set ledStatus to 0
        setLedStatus(0);
      } else {
        // Set ledStatus to 1
        setLedStatus(1);
      }

      // Toggle the LED based on the updated ledStatus
      // button1Pressed();
    });
  }

  void setLedStatus(int status) {
    // Your code to set the ledStatus goes here
    DBref.child("LED_STATUS").set(status);

    setState(() {
      ledStatus = status;
    });
    print("Setting ledStatus to $status");
    // Add your logic to control the LED based on the status
  }

  void button1Pressed() {
    // Your existing logic for button1Pressed
    ledStatus == 0
        ? DBref.child('LED_STATUS').set(1)
        : DBref.child('LED_STATUS').set(0);

    // Toggle the local state
    setState(() {
      ledStatus = 1 - ledStatus;
    });
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
        int ldr_value= int.parse(event.snapshot.value.toString());
          if (ldr_value < 600) {
        // Set ledStatus to 0
        DBref.child("LED_STATUS").set(1);
        setState(() {
        ledStatus=1;
          
        });

        
      } else {
         DBref.child("LED_STATUS").set(0);
        setState(() {
        ledStatus=0;
          
        });
      }

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
          style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
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
                  ElevatedButton(
                    onPressed: () {
                      checkLdrValueAndToggleLed();
                    },
                    child: Text(
                      fanStatus == 0 ? 'Turn Fan On' : 'Turn Fan Off',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      button1Pressed();
                    },
                    child: Text(
                      ledStatus == 0 ? 'Turn Light On' : 'Turn Light Off',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      button2Pressed();
                    },
                    child: Text(
                      PumpStatus == 0
                          ? 'Turn Water Pump On'
                          : 'Turn Water Pump Off',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      button3Pressed();
                    },
                    child: Text(
                      WindowStatus == 0 ? 'Slide Window' : 'Shut Windows',
                      style: TextStyle(fontSize: 20),
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
