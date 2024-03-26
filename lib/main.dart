import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_farming/screens/home.dart';
import 'authentication/registration.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn,));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: widget.isLoggedIn ? HomePage() : WelcomePage()
      ,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Large Heading
                Text(
                  'FarmAlly',
                  style: GoogleFonts.monoton(
                    textStyle: TextStyle(
                      fontSize: 45,
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
                SizedBox(height: 20), // Add vertical spacing
                Text(
                  "From Seed to Success with a Single Tap\n"
                      "You don't need to adhere us Formally\n"
                      "All you need is FarmAlly 🌿",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oswald(
                    textStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 100), // Add vertical spacing
                // Row to align logo image button horizontally
                // Replace the GestureDetector with the following code
                // Add vertical spacing
                GestureDetector(
                  onTap: () {
                    // Handle button tap action here
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RegistrationPage(),
                      ),
                    );
                  },

                  child: Column(
                    children: [
                      SizedBox(height: 40), // Add vertical spacing
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logonew.png', // Replace with your logo image path
                            width: 100, // Adjust the width as needed
                            height: 80, // Adjust the height as needed
                          ),
                          Container(
                            width: 150, // Adjust the width as needed
                            height: 150, // Adjust the height as needed
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(110),
                            ),
                          ),
                          Positioned(
                            bottom: 110, // Add small vertical spacing between the image and the text
                            child: Text(
                              'Tap to Dive!',
                              style: GoogleFonts.cinzel(
                                textStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.yellow[100],
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}