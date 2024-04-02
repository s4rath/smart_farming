import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_farming/weed_classification/weeddetail.dart';



class Info extends StatefulWidget
{
  var i;
  Info(this.i);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InfoState(i);
  }

}

class InfoState extends State<Info> {
  var i;

  InfoState(this.i);

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * 0.8; // 80% of the screen width
    double containerHeight = MediaQuery.of(context).size.height * 0.7;

    double photoHeight = MediaQuery
        .of(context)
        .size
        .width * 0.3;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hay.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay to darken the background image
          Container(
            color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, size: 35,),
                      ),
                      Text(
                        details[i].title,
                        style: GoogleFonts.getFont(
                          'Didact Gothic',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),

                  child: Container(
                    width: containerWidth, // Adjust the width
                    height: containerHeight, // Adjust the height
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      // White background color

                      borderRadius: BorderRadius.circular(
                          20), // Circular border
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'About',
                            style: GoogleFonts.getFont(
                              'Didact Gothic',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: photoHeight,
                            width: containerWidth,
                            child: Center(
                              child: details[i]
                                  .photo, // Include details[i].photo here
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            details[i].about,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.getFont(
                              'Didact Gothic',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Management',
                            style: GoogleFonts.getFont(
                              'Didact Gothic',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            details[i].methods,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.getFont(
                              'Didact Gothic',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
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