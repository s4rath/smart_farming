// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:location/location.dart';
// class LocationTest extends StatefulWidget {
//   const LocationTest({super.key});

//   @override
//   State<LocationTest> createState() => _LocationTestState();
// }

// class _LocationTestState extends State<LocationTest> {
//   bool? _serviceEnabled;
//   PermissionStatus? _permissionGranted;
//   Location location = new Location();
//   bool _loading = false;

//   LocationData? _location;
//   String? _error;

//   @override
//   initState() {
//     super.initState();
//   }

//   Future<void> _getLocation() async {
//     setState(() {
//       _error = null;
//       _loading = true;
//     });
//     try {
//       final locationResult = await location.getLocation();
//       setState(() {
//         _location = locationResult;
//         _loading = false;
//       });
//     } on PlatformException catch (err) {
//       setState(() {
//         _error = err.code;
//         _loading = false;
//       });
//     }
//   }

//   Future<void> _checkService() async {
//     final serviceEnabledResult = await location.serviceEnabled();
//     setState(() {
//       _serviceEnabled = serviceEnabledResult;
//     });
//   }

//   Future<void> _requestService() async {
//     if (_serviceEnabled ?? false) {
//       return;
//     }

//     final serviceRequestedResult = await location.requestService();
//     setState(() {
//       _serviceEnabled = serviceRequestedResult;
//     });
//   }

//   Future<void> _checkPermissions() async {
//     final permissionGrantedResult = await location.hasPermission();
//     setState(() {
//       _permissionGranted = permissionGrantedResult;
//     });
//   }

//   Future<void> _requestPermission() async {
//     if (_permissionGranted != PermissionStatus.granted) {
//       final permissionRequestedResult = await location.requestPermission();
//       setState(() {
//         _permissionGranted = permissionRequestedResult;
//       });
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("TodoList"),
//         ),
//         body: Column(
//           children: [
//             Text(
//               'Permission status: ${_permissionGranted ?? "unknown"}',
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             Row(
//               children: <Widget>[
//                 Container(
//                   margin: const EdgeInsets.only(right: 42),
//                   child: ElevatedButton(
//                     onPressed: _checkPermissions,
//                     child: const Text('Check'),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: _permissionGranted == PermissionStatus.granted
//                       ? null
//                       : _requestPermission,
//                   child: const Text('Request'),
//                 ),
//               ],
//             ),
//             Text(
//               'Service enabled: ${_serviceEnabled ?? "unknown"}',
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             Row(
//               children: <Widget>[
//                 Container(
//                   margin: const EdgeInsets.only(right: 42),
//                   child: ElevatedButton(
//                     onPressed: _checkService,
//                     child: const Text('Check'),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed:
//                       (_serviceEnabled ?? false) ? null : _requestService,
//                   child: const Text('Request'),
//                 ),
//               ],
//             ),
//             Text(
//               'Location: ${_error ?? '${_location ?? "unknown"}'}',
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             Row(
//               children: <Widget>[
//                 ElevatedButton(
//                   onPressed: _getLocation,
//                   child: _loading
//                       ? const CircularProgressIndicator(
//                           color: Colors.white,
//                         )
//                       : const Text('Get'),
//                 ),
//               ],
//             ),
//           ],
//         )
       
//         );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationTest extends StatefulWidget {
  const LocationTest({Key? key}) : super(key: key);

  @override
  State<LocationTest> createState() => _LocationTestState();
}

class _LocationTestState extends State<LocationTest> {
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  Location location = Location();
  bool _loading = false;

  LocationData? _location;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    await _checkService();
    await _requestService();
    await _checkPermissions();
    await _requestPermission();
  }

  Future<void> _checkService() async {
    final serviceEnabledResult = await location.serviceEnabled();
    setState(() {
      _serviceEnabled = serviceEnabledResult;
    });
  }

  Future<void> _requestService() async {
    if (_serviceEnabled ?? false) {
      return;
    }

    final serviceRequestedResult = await location.requestService();
    setState(() {
      _serviceEnabled = serviceRequestedResult;
    });
  }

  Future<void> _checkPermissions() async {
    final permissionGrantedResult = await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
    });
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final permissionRequestedResult = await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
    }
  }

  Future<void> _getLocation() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      final locationResult = await location.getLocation();
      setState(() {
        _location = locationResult;
        _loading = false;
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TodoList"),
      ),
      body: Column(
        children: [
          Text(
            'Permission status: ${_permissionGranted ?? "unknown"}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 42),
                child: ElevatedButton(
                  onPressed: _checkPermissions,
                  child: const Text('Check'),
                ),
              ),
              ElevatedButton(
                onPressed: _permissionGranted == PermissionStatus.granted
                    ? null
                    : _requestPermission,
                child: const Text('Request'),
              ),
            ],
          ),
          Text(
            'Service enabled: ${_serviceEnabled ?? "unknown"}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 42),
                child: ElevatedButton(
                  onPressed: _checkService,
                  child: const Text('Check'),
                ),
              ),
              ElevatedButton(
                onPressed: (_serviceEnabled ?? false) ? null : _requestService,
                child: const Text('Request'),
              ),
            ],
          ),
          Text(
            'Location: ${_error ?? '${_location ?? "unknown"}'}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: _getLocation,
                child: _loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Get'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
