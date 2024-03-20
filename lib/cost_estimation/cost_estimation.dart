import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CostEstimationPage extends StatefulWidget {
  @override
  State<CostEstimationPage> createState() => _CostEstimationPageState();
}

class _CostEstimationPageState extends State<CostEstimationPage> {
  final formKey = GlobalKey<FormState>();

  String predictedCrop = "";
   TextEditingController _cropname = TextEditingController();
  TextEditingController _statename = TextEditingController();
  List<Widget> widgets = [];

  Future<void> costEstimate() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final apiUrl = 'http://johnhona1.pythonanywhere.com/cost';
    print(
        "${_cropname.text},${_statename.text}");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "Cropname": _cropname.text,
        "Statename": _statename.text,
      }),
    );

    
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cost Estimation Page'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                // color: Colors.blue.shade800,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/wp1886339.jpg'), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  // height: MediaQuery.of(context).size.height / 1.3,
                  width: MediaQuery.of(context).size.width / 1.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, right: 8, left: 8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _cropname,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Crop Name', hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: new BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                            // keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _statename,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Value";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'State Name', hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                        
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: new BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                            // keyboardType: TextInputType.number,
                          ),
                        ),
                     
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: costEstimate,
                          child: Text('Estimate Cost'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                    
                        
                         SizedBox(
                          height: 10,
                        ),
                       
                      ]
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}