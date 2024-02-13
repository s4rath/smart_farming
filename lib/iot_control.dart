import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IoTControlPage extends StatefulWidget {
  @override
  _IoTControlPageState createState() => _IoTControlPageState();
}

class _IoTControlPageState extends State<IoTControlPage> {
  String ldrValue = '';
  String soilMoistureValue = '';
  String temperatureValue = '';
  String smokeValue = '';
  Timer? timer;
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
    // fetchData();
    // startDataUpdateTimer();
  }

//   void dbRetrieve() async{
//     ldrReference.onValue.listen((DatabaseEvent event) {
//     final data = event.snapshot.value;
//     print(data);
// });

//   }

  // void startDataUpdateTimer() {
  //   const updateInterval = Duration(milliseconds: 500);
  //   timer = Timer.periodic(updateInterval, (_) {
  //     fetchData();
  //   });
  // }

  // Future<void> fetchData() async {
  //   final response = await http.get(
  //     Uri.parse(
  //         'https://api.thingspeak.com/channels/2417550/feeds.json?results=2'),
  //   );

  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     if (json['feeds'] != null && json['feeds'].isNotEmpty) {
  //       setState(() {
  //         ldrValue = json['feeds'][0]['field1'].toString();
  //         soilMoistureValue = json['feeds'][0]['field2'].toString();
  //         temperatureValue = json['feeds'][0]['field3'].toString();
  //         smokeValue = json['feeds'][0]['field4'].toString();
  //       });
  //     }
  //   }
  // }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    DatabaseReference ldrReference =
        FirebaseDatabase.instance.ref().child("Light").child("Ldr_Value");
    DatabaseReference soilReference =
        FirebaseDatabase.instance.ref().child("Soil").child("Soil_Moisture");
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
    return Scaffold(
      appBar: AppBar(
        title: Text('IoT Control'),
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
                  Text('Soil Moisture Value: $soilMoistureValue',
                      style: TextStyle(fontSize: 20)),
                  Text('Temperature Value: $temperatureValue',
                      style: TextStyle(fontSize: 20)),
                  Text('Smoke Value: $smokeValue',
                      style: TextStyle(fontSize: 20)),
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
