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
  String particularYear = "";
  TextEditingController _cropname = TextEditingController();
  TextEditingController _statename = TextEditingController();
  List<Widget> widgets = [];
  final List<String> Years = ['2024', '2025', '2026', '2027', '2028', '2029'];
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
  final List<String> stateItems = [
    'Andhra Pradesh',
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
    'A.P.'
  ];

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
        "year": particularYear
      }),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      widgets.clear();
      print(response.body);
      print(data);
      for (var result in data) {
        double fixedCost = result['OperationalCost'] + result['FixedCost'];
        setState(() {
          widgets.add(Text(
          'Year: ${result['Year']}\n'
          'Operational Cost: ${result['OperationalCost']}\n'
          'Fixed Cost: ${result['FixedCost']}\n'
          'Human Labour: ${result['HumanLabour']}\n'
          'Machine Labour: ${result['MachineLabour']}\n'
          'Fertilizer Manure: ${result['FertilizerManure']}\n'
          'Total Cost: ${fixedCost}\n',
          style: TextStyle(fontSize: 16),
        ));
        });
        
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
          backgroundColor: Color.fromARGB(255, 251,243,210),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
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
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                Center(
                  child: Container(
                    alignment: Alignment.topCenter,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, right: 8, left: 8),
                      child: Column(
                          children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5), // Add some top padding
                                  child: Text(
                                    'Cost Estimation', // Add the heading text here
                                    textAlign: TextAlign
                                        .center, // Aligns the text horizontally within the container
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          17.5, // Adjust the font size as needed
                                      // Adjust the font weight as needed
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      hintText: "Year",
                                      hintStyle: TextStyle(color: Colors.white),
                                      prefixIcon: Icon(
                                        Icons.calendar_month,
                                        color: Colors.white,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6),
                                        ),
                                        borderSide:
                                            new BorderSide(color: Colors.green),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.green),
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 10),
                                    ),
                                    dropdownColor: Colors.white,
                                    items: Years.map((yearItem) {
                                      return DropdownMenuItem<String>(
                                        value: yearItem,
                                        child: Text(yearItem),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      particularYear = value!;
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
                                      color: Colors.white,
                                    ),
                                    isExpanded: true,
                                    elevation: 10,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      hintText: "Crop Name",
                                      hintStyle: TextStyle(color: Colors.white),
                                      prefixIcon: Icon(
                                        Icons.agriculture,
                                        color: Colors.white,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6),
                                        ),
                                        borderSide:
                                            new BorderSide(color: Colors.green),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.green),
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 10),
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
                                      color: Colors.white,
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
                                      hintStyle: TextStyle(color: Colors.white),
                                      prefixIcon: Icon(
                                        Icons.maps_home_work,
                                        color: Colors.white,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6),
                                        ),
                                        borderSide:
                                            new BorderSide(color: Colors.green),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.green),
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 10),
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
                                      color: Colors.white,
                                    ),
                                    isExpanded: true,
                                    elevation: 10,
                                  ),
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () async{
                                   await costEstimate();
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          TextEditingController nm =
                                              TextEditingController();
                                          return AlertDialog(
                                            content: Stack(
                                              clipBehavior: Clip.none,
                                              children:widgets,
                                            ),
                                          );
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 50),
                                    // Adjust padding as needed
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.green,
                                    // Background color
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ), // Text style
                                  ),
                                  child: Text(
                                    'Estimate Cost',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ] ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
