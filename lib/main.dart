import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'registration.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return MaterialApp(debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/photo.jpg', // Replace with your background image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // Black overlay with opacity
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(160.0),
                    child: Row(
                      children: [
                        // Logo Image
                        Image.asset(
                          'assets/images/logonew.png', // Replace with your logo image path
                          width: 80, // Adjust the width as needed
                          height: 80, // Adjust the height as needed
                        ),
                        SizedBox(width: 16), // Add spacing
                        // Large Heading
                        Text(
                          'FarmAlly',
                          style: GoogleFonts.lobster(
                            textStyle: TextStyle(
                              fontSize: 70,
                              color: Colors.white,
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
                      ],
                    ),
                  ),
                  // SizedBox(height: 65), // Add vertical spacing
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 285.0, bottom: 20), // Adjust left padding
                      child: Text(
                        "From Seed to Success with a Single Tap"
                        "\nYou don't need to adhere  us Formally"
                        "\nAll you need is FarmAlly!!!",
                        style: GoogleFonts.playfairDisplay(
                          textStyle: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 10), // Add vertical spacing
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 285.0, bottom: 20), // Adjust left padding
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Adjust the value for desired curvature
                        ),
                      ),
                      onPressed: () {
                        // Navigate to the RegistrationPage when the button is clicked
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegistrationPage(),
                          ),
                        );
                      },
                      child: Text('Get Started ',
                          style: GoogleFonts.lobster(
                            textStyle: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.green,
                                offset: Offset(0, 0),
                              ),
                            ],
                          )),
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
