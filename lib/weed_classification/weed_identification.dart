import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:smart_farming/weed_classification/info.dart';
import 'package:smart_farming/weed_classification/weeddetail.dart';

class WeedIdentificationPage extends StatefulWidget {
  const WeedIdentificationPage({Key? key});

  @override
  State<WeedIdentificationPage> createState() =>
      _WeedIdentificationPageState();
}

class _WeedIdentificationPageState extends State<WeedIdentificationPage> {
  bool loading = false;
  bool _waiting = false;
  late File _image;
  List _output = [];
  final imagepicker = ImagePicker();
  int predictedClass = -1;
  double confidence = 0.0;

  @override
  void initState() {
    super.initState();
    loading = true;
  }

  Future<int> predictImage(File imageFile) async {
    _waiting=true;
    var request = http.MultipartRequest(
        'POST', Uri.parse("http://johnhona1.pythonanywhere.com/weed"));
    request.headers['content-type'] = 'multipart/form-data';
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      int predictedClass = jsonResponse['predicted_class'];
      confidence = jsonResponse['confidence'];
      print(confidence.toStringAsFixed(3));
      return predictedClass;
    } else {
      return -1;
    }
  }

  pickImageCamera() async {
    var image = await imagepicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    } else {
      loading = false;
      setState(() {});
      _image = File(image.path);
    }
    print("here");
    predictedClass = await predictImage(_image);
    print('Predicted class: $predictedClass');
     _waiting=false;
    setState(() {});
  }

  pickImageGallery() async {
    var image = await imagepicker.getImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      loading = false;
      setState(() {});
      _image = File(image.path);
    }
    print("here");
    predictedClass = await predictImage(_image);
    print('Predicted class: $predictedClass');
     _waiting=false;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Weed Identification Page',style: TextStyle(color: Colors.white)),
    backgroundColor: Colors.green.shade900,
    flexibleSpace: Container(
    decoration: BoxDecoration(
    color: Colors.black.withOpacity(0.5),
    ),
    ),
        ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/OIPed.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black12.withOpacity(0.5), // Adjust opacity
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Weed Detector',
                      style: GoogleFonts.getFont(
                        'Didact Gothic',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                    SizedBox(height: 20),

                    Container(
                      height: 139,// Adjust height as needed

                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), // Adjust the radius for rounded corners
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5), // Use the same radius for clipping
                        child: Image.asset(
                          'assets/images/weeder.png',
                          // Set the width of the image
                          fit: BoxFit.cover, // Adjust the fit of the image to cover the entire width
                        ),
                      ),
                    ),

                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            pickImageCamera();
                          },
                          child: Text(
                            'Capture',
                            style: GoogleFonts.getFont(
                              'Didact Gothic',
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 9, vertical: 8),
                          ),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () async {
                            pickImageGallery();
                          },
                          child: Text(
                            'Gallery',
                            style: GoogleFonts.getFont(
                              'Didact Gothic',
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    loading != true
                        ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            height: 120,
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            child: Image.file(
                              _image,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                      
                          SizedBox(height: 10),
                           if(_waiting!=true)
                          if (predictedClass != -1 &&
                              confidence > 0.85)
                            Column(
                              children: [
                                Text(
                                  'Classified as : ${details[predictedClass]
                                      .title} [${confidence.toStringAsFixed(
                                      4)}]',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.getFont(
                                    'Didact Gothic',
                                    color: Colors.teal.shade50,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    if (predictedClass != -1) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Info(predictedClass),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(5),
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Know more',
                                        style: GoogleFonts.getFont(
                                          'Didact Gothic',
                                          color: Colors.green.shade900,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              confidence == 0.0
                                  ? ""
                                  : "Image cannot be detected",
                              style: GoogleFonts.getFont(
                                'Didact Gothic',
                                color: Colors.teal.shade50,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            )
                            else 
                            CircularProgressIndicator()
                        ],
                      ),
                    )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}