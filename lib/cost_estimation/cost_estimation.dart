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
  String stateName = "";
  String cropName = "";
  TextEditingController _cropname = TextEditingController();
  TextEditingController _statename = TextEditingController();
  List<Widget> widgets = [];
  final List<String> cropItems = [
    'ARHAR',
    'Bajra',
    'Cotton',
    'Groundnut',
    'Jowar',
    'Maize',
    'Moong',
    'Nigerseed',
    'Paddy',
    'Ragi',
    'Sesamum',
    'Soyabean',
    'Sunflower'
  ];
  final List<String> stateItems = ['Andhra Pradesh',
 'Bihar',
 'Chhattisgarh',
 'Gujarat',
 'Karnataka',
 'Madhya Pradesh',
 'Maharashtra',
 'Odisha',
 'Tamil Nadu',
 'Telangana',
 'Uttar Pradesh',
 'Haryana',
 'Rajasthan',
 'Punjab',
 'Himachal Pradesh',
 'Jharkhand',
 'Assam',
 'Chhatisgarh',
 'Kerala',
 'Uttarakhand',
 'West Bengal',
 'Orissa',
 'A.P.'];

  Future<void> costEstimate() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final apiUrl = 'http://johnhona1.pythonanywhere.com/cost';
    print("${_cropname.text},${_statename.text}");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "Cropname": cropName,
        "Statename": stateName,
      }),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      widgets.clear();
      print(response.body);
      print(data);
      for (var result in data) {
        widgets.add(Text(
          'Year: ${result['Year']}\n'
          'Operational Cost: ${result['OperationalCost']}\n'
          'Fixed Cost: ${result['FixedCost']}\n'
          'Human Labour: ${result['HumanLabour']}\n'
          'Machine Labour: ${result['MachineLabour']}\n'
          'Fertilizer Manure: ${result['FertilizerManure']}\n',
          style: TextStyle(fontSize: 16),
        ));
      }
    } else {
      print('Failed to estimate cost. Status code: ${response.statusCode}');
    }
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
                          'assets/images/Farmer.jpg'), // Replace with your image path
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
                      padding:
                          const EdgeInsets.only(top: 20, right: 8, left: 8),
                      child: Column(
                          children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      hintText: "Crop Name",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(
                                        Icons.agriculture,
                                        color: Colors.grey,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        borderSide:
                                            new BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey),
                                      ),
                                    ),
                                    dropdownColor: Colors.white,
                                    items: cropItems.map((yearItem) {
                                      return DropdownMenuItem<String>(
                                        value: yearItem,
                                        child: Text(yearItem),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      cropName = value!;
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select an option';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    ),
                                    isExpanded: true,
                                    elevation: 10,
                                  ),
                                ),
                               
                                 Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      hintText: "State Name",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(
                                        Icons.maps_home_work,
                                        color: Colors.grey,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        borderSide:
                                            new BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey),
                                      ),
                                    ),
                                    dropdownColor: Colors.white,
                                    items: stateItems.map((yearItem) {
                                      return DropdownMenuItem<String>(
                                        value: yearItem,
                                        child: Text(yearItem),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      stateName = value!;
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select an option';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    ),
                                    isExpanded: true,
                                    elevation: 10,
                                  ),
                                ),
                              
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: costEstimate,
                                  child: Text('Estimate Cost'),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ] +
                              widgets),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}