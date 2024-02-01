import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CropPredictionAuto extends StatefulWidget {
  const CropPredictionAuto({super.key});

  @override
  State<CropPredictionAuto> createState() => _CropPredictionAutoState();
}

class _CropPredictionAutoState extends State<CropPredictionAuto> {
  Position? _currentPosition;
  double? latitude;
  double? longitude;
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
        latitude=position.latitude;
        longitude=position.longitude;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Crop Prediction Automatic"),),
      body: Container(width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_currentPosition != null)
              Text(
                  "LAT: ${_currentPosition!.latitude}, LNG: ${_currentPosition!.longitude}"),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text("Get location"),
              onPressed: () {
                _checkLocationPermission();
              },
            ),
          ],
        ),
      ),
    );
  }
}
