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
//       home: WeedIdentificationPage(),
//     );
//   }
// }

class WeedIdentificationPage extends StatefulWidget {
  @override
  State<WeedIdentificationPage> createState() => _WeedIdentificationPageState();
}

class _WeedIdentificationPageState extends State<WeedIdentificationPage> {
  final imagepicker = ImagePicker();
  bool loading = false;
  late File _image;
  List _output = [];

  void initState() {
    super.initState();
    loading = true;
    // loadmodel().then((value) {
    //   print(value);
    //   print('on the detect page');
    //   setState(() {});
    // });
  }

  detectimage(File image) async {
    print(image.path);
    // var prediction = await Tflite.runModelOnImage(
    //   path: image.path,
    //   numResults: 12,
    //   // threshold: 0.45,
    // );
    // print("predictions are $prediction");
    setState(() {
      // _output = prediction!;
      // print(_output[0]['confidence']);
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

  // loadmodel() async {
  //   var res = await Tflite.loadModel(
  //     model: 'assets/pest_model/unquantized.tflite',
  //     labels: 'assets/pest_model/labels.txt',
  //   );
  //   print("Result after loading the model: $res");
  // }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Weed Identification Page'),
        ),
        body: Container(
          height: h,
          width: w,
          child: Column(
            children: [
              SizedBox(
                height: 90,
              ),
              Container(
                  child: Text(
                'Pest Detector',
                style: GoogleFonts.getFont('Didact Gothic',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              )),
              SizedBox(
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
                child: Image.asset('assets/images/weed.png'),
              ),
              SizedBox(height: 30),
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
              )
            ],
          ),
        ));
  }
}
