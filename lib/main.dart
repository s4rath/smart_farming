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
        body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/images/photo.jpg'), 
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          Padding(
            padding: const EdgeInsets.only(
                left: 0, bottom: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20), 
                ),
              ),
              onPressed: () {
                
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegistrationPage(),
                  ),
                );
              },
              child: Text('Get Started',
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
    )
        // Stack(
        //   children: [
        //     // Background Image
        //     Image.asset(
        //       'assets/images/photo.jpg', // Replace with your background image path
        //       fit: BoxFit.cover,
        //       width: double.infinity,
        //       height: double.infinity,
        //     ),
        //     Container(
        //       color: Colors.black.withOpacity(0.5), // Black overlay with opacity
        //       width: double.infinity,
        //       height: double.infinity,
        //     ),
        //     Center(
        //       child: Align(
        //         alignment: Alignment.centerLeft,
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Padding(
        //               padding: const EdgeInsets.all(160.0),
        //               child: Row(
        //                 children: [
        //                   // Logo Image
        //                   Image.asset(
        //                     'assets/images/logonew.png', // Replace with your logo image path
        //                     width: 80, // Adjust the width as needed
        //                     height: 80, // Adjust the height as needed
        //                   ),
        //                   SizedBox(width: 16), // Add spacing
        //                   // Large Heading
        //                   Text(
        //                     'FarmAlly',
        //                     style: GoogleFonts.lobster(
        //                       textStyle: TextStyle(
        //                         fontSize: 70,
        //                         color: Colors.white,
        //                       ),
        //                       shadows: [
        //                         Shadow(
        //                           blurRadius: 10.0,
        //                           color: Colors.green,
        //                           offset: Offset(0, 0),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             // SizedBox(height: 65), // Add vertical spacing
        //             Expanded(
        //               child: Padding(
        //                 padding: const EdgeInsets.only(
        //                     left: 285.0, bottom: 20), // Adjust left padding
        //                 child: Text(
        //                   "From Seed to Success with a Single Tap"
        //                   "\nYou don't need to adhere  us Formally"
        //                   "\nAll you need is FarmAlly!!!",
        //                   style: GoogleFonts.playfairDisplay(
        //                     textStyle: TextStyle(
        //                       fontSize: 24,
        //                       color: Colors.white,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             // SizedBox(height: 10), // Add vertical spacing
        //             Padding(
        //               padding: const EdgeInsets.only(
        //                   left: 285.0, bottom: 20), // Adjust left padding
        //               child: ElevatedButton(
        //                 style: ElevatedButton.styleFrom(
        //                   backgroundColor: Colors.transparent,
        //                   foregroundColor: Colors.black,
        //                   elevation: 0,
        //                   shape: RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.circular(
        //                         20), // Adjust the value for desired curvature
        //                   ),
        //                 ),
        //                 onPressed: () {
        //                   // Navigate to the RegistrationPage when the button is clicked
        //                   Navigator.of(context).push(
        //                     MaterialPageRoute(
        //                       builder: (context) => RegistrationPage(),
        //                     ),
        //                   );
        //                 },
        //                 child: Text('Get Started',
        //                     style: GoogleFonts.lobster(
        //                       textStyle: TextStyle(
        //                         fontSize: 40,
        //                         color: Colors.white,
        //                       ),
        //                       shadows: [
        //                         Shadow(
        //                           blurRadius: 10.0,
        //                           color: Colors.green,
        //                           offset: Offset(0, 0),
        //                         ),
        //                       ],
        //                     )),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}
