import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: FirebaseOptions(
//       apiKey: "AIzaSyCBu8vdXeeYGdHeZjbY8kyve4kBWsqLUSI",
//       authDomain: "smart-farming-90da3.firebaseapp.com",
//       databaseURL:
//           "https://smart-farming-90da3-default-rtdb.asia-southeast1.firebasedatabase.app",
//       projectId: "smart-farming-90da3",
//       storageBucket: "smart-farming-90da3.appspot.com",
//       messagingSenderId: "246762168818",
//       appId: "1:246762168818:web:dc8b00561dba01dfa10b6b",
//       measurementId: "G-3WG51DGV1P",
//     ), // Initialize Firebase
//   );

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login Page',
//       theme: ThemeData(
//         primaryColor: Colors.white54,
//         fontFamily: 'Montserrat', // Custom font
//       ),
//       home: LoginPage(),
//     );
//   }
// }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  String _loginError = '';

  Future<void> _login() async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Login successful, navigate to the home page or any other desired page.
      // Replace HomePage with the actual home page class.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      setState(() {
        _loginError = 'Invalid email or password. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/wp1886339.jpg', // Replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 600,
                height: 500, // Increased container height
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Left Background Image Inside the Container
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.56, // 40% width
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/16317-29175.jpg'), // Replace with your image path
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.transparent, // Make the image transparent
                              BlendMode.srcOver,
                            ),
                            child: Container(
                              color: Colors
                                  .transparent, // No background color needed here
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16), // Add spacing
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Email TextField
                              TextFormField(
                                controller: _emailController,
                                style: TextStyle(
                                  fontSize: 20, // Increased font size
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20, // Increased font size
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide:
                                        BorderSide(color: Colors.lightGreen),
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
                              SizedBox(height: 20), // Increased vertical space
                              // Password TextField
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                style: TextStyle(
                                  fontSize: 20, // Increased font size
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20, // Increased font size
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide:
                                        BorderSide(color: Colors.lightGreen),
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
                              SizedBox(height: 30), // Increased vertical space
                              // Login Button
                              ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  minimumSize: Size(300, 50),
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 20),
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
