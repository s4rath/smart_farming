import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_farming/main.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCBu8vdXeeYGdHeZjbY8kyve4kBWsqLUSI",
        authDomain: "smart-farming-90da3.firebaseapp.com",
        databaseURL:
            "https://smart-farming-90da3-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "smart-farming-90da3",
        storageBucket: "smart-farming-90da3.appspot.com",
        messagingSenderId: "246762168818",
        appId: "1:246762168818:web:dc8b00561dba01dfa10b6b",
        measurementId: "G-3WG51DGV1P" // Initialize Firebase

        ),
  ); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  String _registrationError = '';

  Future<void> _register() async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Registration successful, navigate to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginPage()), // Replace LoginPage with the actual login page class
      );
    } catch (e) {
      setState(() {
        _registrationError = 'The Email is already in use, Please Login';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: Stack(
        children: [
          // Background Image Outside the Container
          Image.asset(
            'assets/images/1598244.jpg', // Replace with your outside image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6, // 80% width
              height: MediaQuery.of(context).size.height * 0.71, // 80% height
              color: Colors.black.withOpacity(0.3), // Background overlay color
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left Background Image Inside the Container
                  Container(
                    width:
                        MediaQuery.of(context).size.width * 0.35, // 40% width
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/sidepic.jpg'), // Replace with your left image path
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.transparent, // Adjust opacity as needed
                        BlendMode.srcOver,
                      ),
                      child: Container(
                        color: Colors
                            .transparent, // No background color needed here
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width *
                                  0.6, // 30% width
                              // Registration Content
                              child: Column(
                                children: <Widget>[
                                  TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20, // Increased font size
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                            color: Colors.lightGreen),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(15),
                                          right: Radius.circular(3),
                                        ),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20, // Increased font size
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                            color: Colors.lightGreen),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(15),
                                          right: Radius.circular(3),
                                        ),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: _register,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      minimumSize: Size(300, 50),
                                    ),
                                    child: Text('Register'),
                                  ),
                                  SizedBox(height: 10), // Add spacing
                                  Text('Or',
                                      style: TextStyle(color: Colors.white)),
                                  SizedBox(height: 10), // Add spacing
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      minimumSize: Size(300, 50),
                                    ),
                                    onPressed: () {
                                      // Navigate to the login page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginPage()), // Replace LoginPage with the actual login page class
                                      );
                                    },
                                    child: Text('Login'),
                                  ),
                                  if (_registrationError.isNotEmpty)
                                    Text(
                                      _registrationError,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                ],
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
        ],
      ),
    );
  }
}
