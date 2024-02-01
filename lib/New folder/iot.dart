// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class IoTControlPage extends StatefulWidget {
//   @override
//   _IoTControlPageState createState() => _IoTControlPageState();
// }

// class _IoTControlPageState extends State<IoTControlPage> {
//   String ldrValue = '';
//   String soilMoistureValue = '';
//   String temperatureValue = '';
//   String smokeValue = '';
//   Timer? timer;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//     startDataUpdateTimer();
//   }

//   void startDataUpdateTimer() {
//     const updateInterval = Duration(milliseconds: 500);
//     timer = Timer.periodic(updateInterval, (_) {
//       fetchData();
//     });
//   }

//   Future<void> fetchData() async {
//     final response = await http.get(
//       Uri.parse(
//           'https://api.thingspeak.com/channels/2417550/feeds.json?results=2'),
//     );

//     if (response.statusCode == 200) {
//       final json = jsonDecode(response.body);
//       if (json['feeds'] != null && json['feeds'].isNotEmpty) {
//         setState(() {
//           ldrValue = json['feeds'][0]['field1'].toString();
//           soilMoistureValue = json['feeds'][0]['field2'].toString();
//           temperatureValue = json['feeds'][0]['field3'].toString();
//           smokeValue = json['feeds'][0]['field4'].toString();
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('IoT Control'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('LDR Value: $ldrValue'),
//             Text('Soil Moisture Value: $soilMoistureValue'),
//             Text('Temperature Value: $temperatureValue'),
//             Text('Smoke Value: $smokeValue'),
//           ],
//         ),
//       ),
//     );
//   }
// }

