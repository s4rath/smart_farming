import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_farming/crop_prediction/crop_predictHome.dart';
import 'package:smart_farming/iot_control/iot_control.dart';
import 'package:smart_farming/authentication/login.dart';
import 'package:smart_farming/news_letter/news_home.dart';
import '../cost_estimation/cost_estimation.dart';
import '../pest_classification/pest_identification.dart';
import '../weed_classification/weed_identification.dart';
import '../crop_prediction/crop_prediction.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imagePaths = [
    'assets/images/crop.png',
    'assets/images/weedicon.png',
    'assets/images/pesticon.png',
    'assets/images/cost.png',
    'assets/images/iot-modified.png',
    'assets/images/news-modified.png',
  ];

  final List<String> pageNames = [
    'Crop Prediction',
    'Weed Identification',
    'Pest Identification',
    'Cost Estimation',
    'Greenhouse Control',
    'News Letter'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Color.fromARGB(255,213,159,100),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        actions: [
          PopupMenuButton<String>(
            child: Icon(Icons.more_vert,color: Colors.black,),
            onSelected: (String value) async {
              switch (value) {
                case 'logout':
                  {
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    prefs.setBool('isLoggedIn', false);
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((ctx) {
                            return LoginPage();
                          })));
                    });
                  }
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
             
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          // Background image of the screen
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/nell.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Black overlay with lower opacity covering the screen background image
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.3), // Lower opacity
          ),
          // Container with background image to embed all buttons
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), // Adjust the value for more or less circular edges
                image: DecorationImage(
                  image: AssetImage('assets/images/cover.jpeg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: buildIconRows(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  List<Widget> buildIconRows(BuildContext context) {
    List<Widget> iconButtons = [];
    for (int i = 0; i < imagePaths.length; i++) {
      iconButtons.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: buildIconButton(context, i),
        ),
      );
    }
    return [
      Text(
        'Services',
        style: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 20,

        ),
      ),
      SizedBox(height: 5), // Add some spacing between heading and buttons
      Column(
        children: iconButtons,
      ),
    ];
  }

  Widget buildIconButton(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        navigateToPage(context, index);
      },
      child: Container(
        width: 200,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7), // Adjust opacity here
          borderRadius: BorderRadius.circular(60),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePaths[index],
                width: 65,
                height: 43,
              ),
              // Adjust spacing between image and text
              Text(
                pageNames[index], // Add text here
                style: GoogleFonts.notoSansArmenian( // Example of applying Google Fonts
                  color: Colors.white, // Adjust text color here
                  fontSize: 12,


                  shadows: [
                    Shadow(
                      blurRadius: 20.0,
                      color: Colors.black,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
 void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Access Denied'),
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
  Future<void> navigateToPage(BuildContext context, int index) async {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropPredictionHome(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeedIdentificationPage(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PestIdentificationPage(),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CostEstimationPage(),
          ),
        );
        break;
      case 4:{
         SharedPreferences prefs = await SharedPreferences.getInstance();
              bool greenAccess =  prefs.getBool('greenHouseAccess')?? false;
              greenAccess?
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IoTControlPage(),
          ),
        ): _showErrorDialog(context,"Green House Id Missing");
        }
        break;
        case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsHomePage(),
          ),
        );
        break;
    }
  }
}