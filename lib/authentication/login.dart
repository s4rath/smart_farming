import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/home.dart';

import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  String _loginError = '';
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> _login(BuildContext context) async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;

      // Perform login
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the UUID of the logged-in user

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);

      _showGreenhouseDialog(context);

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage()),
      // );
    } catch (e) {
      setState(() {
        _loginError = 'Invalid email or password. Please try again.';
      });
    }
  }

  void _showGreenhouseDialog(BuildContext context) {
    String? greenhouseId;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Greenhouse ID'),
          content: TextField(
            onChanged: (value) {
              greenhouseId = value;
            },
            decoration: const InputDecoration(hintText: 'Greenhouse ID'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('greenHouseAccess', false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Skip'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (greenhouseId != null && greenhouseId!.isNotEmpty) {
                  final querySnapshot = await FirebaseFirestore.instance
                      .collection('greenhouse')
                      .where('green_id', isEqualTo: greenhouseId)
                      .get();
                  if (querySnapshot.docs.isEmpty) {
                    _showErrorDialog(context, 'Invalid Greenhouse ID');
                  } else {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final userDocSnapshot = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .get();
                      if (userDocSnapshot.exists) {
                        // Check if the email matches
                        print(user.email);
                        if (userDocSnapshot.data()?['email'] == user.email) {
                          // Fetch greenhouse data associated with the user's email
                          final greenhouseSnapshot = await FirebaseFirestore
                              .instance
                              .collection('greenhouse')
                              .doc(user
                                  .email) // Assuming email is the document ID
                              .get();
                              print(greenhouseSnapshot);
                          if (greenhouseSnapshot.exists) {
                            final String? userGreenId =
                                greenhouseSnapshot.data()?['green_id'];
                                print(userGreenId);
                            if (userGreenId != null &&
                                userGreenId == greenhouseId) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('greenHouseAccess', true);

                              final String? uuid = user.uid;
                              if (uuid != null) {
                                // Get FCM token
                                final String? fcmToken =
                                    await _firebaseMessaging.getToken();
                                if (fcmToken != null) {
                                  // Save FCM token to Firebase Realtime Database under fcmToken node
                                  await FirebaseDatabase.instance
                                      .reference()
                                      .child('fcmToken')
                                      .child(uuid)
                                      .set(fcmToken);
                                  print(
                                      'FCM token saved for user with UUID: $uuid');
                                } else {
                                  print('Failed to get FCM token.');
                                }
                              }

                              _showSuccessDialog(context);
                            } else {
                              // Greenhouse ID does not match
                              _showErrorDialog(
                                  context, 'Invalid Greenhouse ID');
                            }
                          } else {
                            // Greenhouse document does not exist
                            _showErrorDialog(
                                context, 'Greenhouse document not found');
                          }
                        } else {
                          // Email does not match
                          _showErrorDialog(context, 'Email does not match');
                        }
                      } else {
                        // User document does not exist
                        _showErrorDialog(context, 'User document not found');
                      }
                    } else {
                      // User is not authenticated
                      _showErrorDialog(context, 'User not authenticated');
                    }
                  }
                } else {
                  // Greenhouse ID is not provided
                  _showErrorDialog(context, 'Please enter Greenhouse ID');
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Greenhouse ID added successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigate to homepage on success
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Stack(
        children: [
          // Background image of the screen
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/1598244.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Black overlay with lower opacity covering the screen background image
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5), // Lower opacity
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Circular edges
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/images/hay.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      // Overlay color with opacity
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Welcome Back!',
                        style: GoogleFonts.notoSansArmenian(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.green,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40), // Email TextField
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15, // Increased font size
                        ),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15, // Increased font size
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.lightGreen),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(15),
                              right: Radius.circular(3),
                            ),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 15), // Increased vertical space
                      // Password TextField
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20, // Increased font size
                        ),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15, // Increased font size
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.lightGreen),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(15),
                              right: Radius.circular(3),
                            ),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 30), // Increased vertical space
                      // Login Button
                      ElevatedButton(
                        onPressed: () {
                          _login(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.amber.shade100.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          minimumSize: Size(300, 50),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      // Error Message
                      if (_loginError.isNotEmpty)
                        Text(
                          _loginError,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//  ElevatedButton(
//               onPressed: () async {
//                 if (greenhouseId != null && greenhouseId!.isNotEmpty) {
//                   final querySnapshot = await FirebaseFirestore.instance
//                       .collection('greenhouse')
//                       .where('green_id', isEqualTo: greenhouseId)
//                       .get();
//                   if (querySnapshot.docs.isEmpty) {
//                     _showErrorDialog(context, 'Invalid Greenhouse ID');
//                   } else {
//                     SharedPreferences prefs =
//                         await SharedPreferences.getInstance();
//                     prefs.setBool('greenHouseAccess', true);
//                     User? user = FirebaseAuth.instance.currentUser;
//                     FirebaseFirestore.instance
//                         .collection("users")
//                         .doc(user!.uid)
//                         .set({
//                       'green_id': greenhouseId,
//                     });
//                     final String? uuid = user.uid;

//                     if (uuid != null) {
//                       // Get FCM token
//                       final String? fcmToken =
//                           await _firebaseMessaging.getToken();

//                       if (fcmToken != null) {
//                         // Save FCM token to Firebase Realtime Database under fcmToken node
//                         await FirebaseDatabase.instance
//                             .reference()
//                             .child('fcmToken')
//                             .child(uuid)
//                             .set(fcmToken);

//                         print('FCM token saved for user with UUID: $uuid');
//                       } else {
//                         print('Failed to get FCM token.');
//                       }
//                     }
//                     _showSuccessDialog(context);
//                   }
//                 } else {
//                   // Greenhouse ID is not provided, show error dialog
//                   _showErrorDialog(context, 'Please enter Greenhouse ID');
//                 }
//               },
//               child: Text('Submit'),
//             ),