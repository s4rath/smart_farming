import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


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
  String predictedClass="";
    @override
  void initState() {
    super.initState();
    loading = true;
    // loadmodel().then((value) {
    //   print(value);
    //   print('on the detect page');
    //   setState(() {});
    // });
   

   
  }


   @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future<String> predictImage(File imageFile) async {

    var request = http.MultipartRequest('POST', Uri.parse("http://johnhona1.pythonanywhere.com/pest"));
    request.headers['content-type'] = 'multipart/form-data';
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      String predictedClass = jsonResponse['predicted_class'];
      return predictedClass;
    } else {
      return "null";
    }
  }


    pickimage_camera() async {
    var image = await imagepicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    } else {
       loading=false;
      setState(() {
        
      });
      _image = File(image.path);
     
    }
    
    print("here");
    predictedClass =await predictImage(_image);
    print('Predicted class: $predictedClass');
     setState(() {
      
    });
  }

   pickimage_gallery() async {
    var image = await imagepicker.getImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      loading=false;
      setState(() {
        
      });
      _image = File(image.path);
      
    }
    print("here");
   
    predictedClass =await predictImage(_image);
    print('Predicted class: $predictedClass');
     setState(() {
      
    });
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
                           if (predictedClass !="" )
                           Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Classified as : $predictedClass',
                                    style: GoogleFonts.getFont('Didact Gothic',
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                ],
                              )
                              else Text( "",
                                // _output[0]["label"]!=null?
                                // 'Image cannot be detected likely to be ${_output[0]["label"]}':"Image cannot be detected",
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

                                     if (_output.isNotEmpty )
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