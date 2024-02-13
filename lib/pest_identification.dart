import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: PestIdentificationPage(),
//     );
//   }
// }

class PestIdentificationPage extends StatefulWidget {
  const PestIdentificationPage({super.key});

  @override
  State<PestIdentificationPage> createState() => _PestIdentificationPageState();
}

class _PestIdentificationPageState extends State<PestIdentificationPage> {

  bool loading = false;
  late File _image;
  List _output = [];
  final imagepicker = ImagePicker();
    @override
  void initState() {
    super.initState();
    loading = true;
    loadmodel().then((value) {
      print(value);
      print('on the detect page');
      setState(() {});
    });
   

   
  }

  detectimage(File image) async {
    print(image.path);
    var prediction = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 12,
      // threshold: 0.45,
    );
    print("predictions are $prediction");
    setState(() {
      _output = prediction!;
      print(_output[0]['confidence']);
      loading = false;
    });
    
  }
   @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
    pickimage_camera() async {
    var image = await imagepicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detectimage(_image);
  }

   pickimage_gallery() async {
    var image = await imagepicker.getImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    print("here");
    detectimage(_image);
  }

   loadmodel() async {
    var res = await Tflite.loadModel(
      model: 'assets/pest_model/pests-98.44.tflite',
      labels: 'assets/pest_model/labels.txt',
    );
    print("Result after loading the model: $res");
  }
  @override
  Widget build(BuildContext context) {
     var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pest Identification Page'),
      ),
      body:Container(
        height: h,
        width: w,
        child: Column(
          children: [
            SizedBox(
              height: 90,
            ), Container(
                child: Text(
              'Pest Detector',
              style: GoogleFonts.getFont('Didact Gothic',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            )),SizedBox(
              height: 20,
            ),
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              //color: Colors.black,
              padding: EdgeInsets.all(10),
              child: Image.asset('assets/images/pest.png'),
            ), SizedBox(height: 30),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 60,
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Capture',
                          style: GoogleFonts.getFont('Didact Gothic',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        onPressed: () async {
                          pickimage_camera();
                        }),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 60,
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Gallery',
                          style: GoogleFonts.getFont('Didact Gothic',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        onPressed: () async {
                          pickimage_gallery();
                        }),
                  ),
                   SizedBox(
              height: 20,
            ),
                ],
              ),
            ),SizedBox(height: 20,),
            loading != true
                ? Container(
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFF7CC00),
                          ),
                          // width: double.infinity,
                          padding: EdgeInsets.all(15),
                          child: Image.file(
                            _image,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                           if (_output.isNotEmpty && _output[0]['confidence']>0.6)
                           Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Classified as : ${_output[0]['label'].toString()}',
                                    style: GoogleFonts.getFont('Didact Gothic',
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                ],
                              )
                              else Text(
                                _output[0]["label"]!=null?
                                'Image cannot be detected likely to be ${_output[0]["label"]}':"Image cannot be detected",
                                style: GoogleFonts.getFont('Didact Gothic',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),


                        // _output.isNotEmpty
                        //     ? Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //             'Classified as : ${_output[0]['label'].toString()}',
                        //             style: GoogleFonts.getFont('Didact Gothic',
                        //                 color: Colors.black,
                        //                 fontWeight: FontWeight.bold,
                        //                 fontSize: 22),
                        //           ),
                        //         ],
                        //       )
                        //     : Text(
                        //         'Image cannot be detected',
                        //         style: GoogleFonts.getFont('Didact Gothic',
                        //             color: Colors.black,
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 22),
                        //       ),

                                     if (_output.isNotEmpty && _output[0]['confidence']>0.6)
                                     Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 20, right: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (_output.isNotEmpty) {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => Info(
                                          //             _output[0]['index'])));
                                        }
                                      },
                                      child: Container(
                                        height: 60,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.black,
                                        ),
                                        child: Center(
                                            child: Text(
                                          'Know more',
                                          style: GoogleFonts.getFont(
                                              'Didact Gothic',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26),
                                        )),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (_output.isNotEmpty) {
                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(builder: (ctx) {
                                          //   return FeeDBack();
                                          // }));
                                        }
                                      },
                                      child: Container(
                                        height: 30,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.black,
                                        ),
                                        child: Center(
                                            child: Text(
                                          'Feedback',
                                          style: GoogleFonts.getFont(
                                              'Didact Gothic',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26),
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              else Container(),

                        // _output.isNotEmpty
                        //     ? Column(
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.only(
                        //                 top: 10, left: 20, right: 20),
                        //             child: GestureDetector(
                        //               onTap: () {
                        //                 if (_output.isNotEmpty) {
                        //                   Navigator.push(
                        //                       context,
                        //                       MaterialPageRoute(
                        //                           builder: (context) => Info(
                        //                               _output[0]['index'])));
                        //                 }
                        //               },
                        //               child: Container(
                        //                 height: 60,
                        //                 width: double.infinity,
                        //                 decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(10),
                        //                   color: Colors.black,
                        //                 ),
                        //                 child: Center(
                        //                     child: Text(
                        //                   'Know more',
                        //                   style: GoogleFonts.getFont(
                        //                       'Didact Gothic',
                        //                       color: Colors.white,
                        //                       fontWeight: FontWeight.bold,
                        //                       fontSize: 26),
                        //                 )),
                        //               ),
                        //             ),
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.only(
                        //                 left: 20, right: 20, top: 10),
                        //             child: GestureDetector(
                        //               onTap: () {
                        //                 if (_output.isNotEmpty) {
                        //                   Navigator.of(context).push(
                        //                       MaterialPageRoute(builder: (ctx) {
                        //                     return FeeDBack();
                        //                   }));
                        //                 }
                        //               },
                        //               child: Container(
                        //                 height: 30,
                        //                 width: double.infinity,
                        //                 decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(10),
                        //                   color: Colors.black,
                        //                 ),
                        //                 child: Center(
                        //                     child: Text(
                        //                   'Feedback',
                        //                   style: GoogleFonts.getFont(
                        //                       'Didact Gothic',
                        //                       color: Colors.white,
                        //                       fontWeight: FontWeight.bold,
                        //                       fontSize: 26),
                        //                 )),
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       )


                        //     : Container()
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      )
    );
  }
}