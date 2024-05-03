import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:smart_farming/pest_classification/info.dart';
import 'package:smart_farming/pest_classification/pestdetail.dart';

import '../services/firebase_fun.dart';

class PestIdentificationPage extends StatefulWidget {
  const PestIdentificationPage({super.key});

  @override
  State<PestIdentificationPage> createState() => _PestIdentificationPageState();
}

class _PestIdentificationPageState extends State<PestIdentificationPage> {
  bool loading = false;
  late File _image;
  // List _output = [];
  final imagepicker = ImagePicker();
  int predictedClass = -1;
  double confidence = 0.0;
  bool _waiting = false;

  @override
  void initState() {
    super.initState();
    loading = true;
  }

  Future<int> predictImage(File imageFile) async {
    _waiting = true;
    var request = http.MultipartRequest(
        'POST', Uri.parse("http://johnhona1.pythonanywhere.com/pest"));
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

  pickimage_camera() async {
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
     await functionDBCall("Pest Classification",confidence > 0.85? "${details[predictedClass].title}":"Image not detected");
    _waiting = false;
    setState(() {});
  }

  pickimage_gallery() async {
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
    await functionDBCall("Pest Classification",confidence > 0.85? "${details[predictedClass].title}":"Image not detected");
    _waiting = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pest Identification Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.limeAccent.shade700,
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
                image: AssetImage('assets/images/weedcover.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.4),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Pest Detector',
                      style: GoogleFonts.getFont(
                        'Didact Gothic',
                        color: Colors.lightGreen.shade100,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 120,
                      width: 200,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          'assets/images/design.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            pickimage_camera();
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
                            backgroundColor: Colors.lightGreen.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 9, vertical: 8),
                          ),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () async {
                            pickimage_gallery();
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
                            backgroundColor: Colors.lightGreen.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 9, vertical: 8),
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
                                  height: 110,
                                  width: 180,
                                  padding: EdgeInsets.all(12),
                                  child: Image.file(
                                    _image,
                                    fit: BoxFit.fitWidth,
                                    height: 110,
                                  ),
                                ),
                                SizedBox(height: 10),
                                if (_waiting != true)
                                  if (predictedClass != -1 && confidence > 0.85)
                                    Column(
                                      children: [
                                        Text(
                                          'Classified as : ${details[predictedClass].title} [${confidence.toStringAsFixed(4)}]',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.getFont(
                                            'Didact Gothic',
                                            color: Colors.lightGreen.shade100,
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
                                              color: Colors.lightGreen.shade100,
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
                                        color: Colors.lightGreen.shade100,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
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
