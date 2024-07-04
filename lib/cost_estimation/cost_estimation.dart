import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_farming/services/firebase_fun.dart';

class CostEstimationPage extends StatefulWidget {
  @override
  State<CostEstimationPage> createState() => _CostEstimationPageState();
}

class _CostEstimationPageState extends State<CostEstimationPage> {
  final formKey = GlobalKey<FormState>();
  String area = "";
  String predictedCrop = "";
  bool isFetching = false;
  String stateName = "";
  String cropName = "";
  String particularYear = "";
  bool isCostEstimated = false;
  TextEditingController _cropname = TextEditingController();
  TextEditingController _statename = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  List<Widget> widgets = [];
  final List<String> Years = [
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
    '2031'
  ];
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
        double operationalCost = result['OperationalCost'] * double.parse(area);
        double fixedCost = result['FixedCost'] * double.parse(area);
        double humanLabour = result['HumanLabour'] * double.parse(area);
        double machineLabour = result['MachineLabour'] * double.parse(area);
        double fertilizerManure =
            result['FertilizerManure'] * double.parse(area);
        double totalCost = fixedCost +
            operationalCost +
            humanLabour +
            machineLabour +
            fertilizerManure;

        setState(() {
          widgets.add(Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Forecasted Cost for Year:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                TextSpan(
                  text: '${result['Year']}\n',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                TextSpan(
                  text: 'Operational Cost: $operationalCost\n'
                      'Fixed Cost: $fixedCost\n'
                      'Human Labour: $humanLabour\n'
                      'Machine Labour: $machineLabour\n'
                      'Fertilizer Manure: $fertilizerManure\n'
                      'Total Cost: $totalCost\n',
                  style: TextStyle(fontSize: 12.5, color: Colors.white),
                ),
              ],
            ),
          ));
        });
      }

      await functionDBCall("Cost Estimation", "$data");
    } else {
      print('Failed to estimate cost. Status code: ${response.statusCode}');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cost Estimation Page',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 251, 243, 210),
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
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Farmer.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 17, right: 8, left: 8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5), // Add some top padding
                            child: Text(
                              'Cost Estimation', // Add the heading text here
                              textAlign: TextAlign.center,
                              // Aligns the text horizontally within the container
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight
                                    .bold, // Adjust the font size as needed
                                // Adjust the font weight as needed
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: "Year",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.calendar_month,
                                  color: Colors.white,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                  borderSide: new BorderSide(
                                      color:
                                          Color.fromARGB(255, 251, 243, 210)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color:
                                          Color.fromARGB(255, 251, 243, 210)),
                                ),
                                labelStyle: TextStyle(color: Colors.white),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10),
                              ),
                              dropdownColor: Colors.white,
                              items: Years.map((yearItem) {
                                return DropdownMenuItem<String>(
                                  value: yearItem,
                                  child: Text(
                                    yearItem,
                                    style: TextStyle(color: Colors.black),
                                  ),
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
                                color: Colors
                                    .white, // Set the color of dropdown button text
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              selectedItemBuilder: (BuildContext context) {
                                return Years.map<Widget>((String item) {
                                  return Text(item,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ) // Set the color of selected item text
                                      );
                                }).toList();
                              },
                              isExpanded: true,
                              elevation: 10,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: "Crop Name",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.agriculture,
                                  color: Colors.white,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                  borderSide: new BorderSide(
                                      color:
                                          Color.fromARGB(255, 251, 243, 210)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color:
                                          Color.fromARGB(255, 251, 243, 210)),
                                ),
                                labelStyle: TextStyle(color: Colors.white),
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
                              selectedItemBuilder: (BuildContext context) {
                                return cropItems.map<Widget>((String item) {
                                  return Text(item,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ) // Set the color of selected item text
                                      );
                                }).toList();
                              },
                              isExpanded: true,
                              elevation: 10,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: "State Name",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.maps_home_work,
                                  color: Colors.white,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                  borderSide: new BorderSide(
                                      color:
                                          Color.fromARGB(255, 251, 243, 210)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color:
                                          Color.fromARGB(255, 251, 243, 210)),
                                ),
                                labelStyle: TextStyle(color: Colors.white),
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
                              selectedItemBuilder: (BuildContext context) {
                                return stateItems.map<Widget>((String item) {
                                  return Text(item,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ) // Set the color of selected item text
                                      );
                                }).toList();
                              },
                              isExpanded: true,
                              elevation: 10,
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              // Input for Area
                              controller: _areaController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Area(hectare)',
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.landscape,
                                  color: Colors.white,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 251, 243, 210)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color:
                                          Color.fromARGB(255, 251, 243, 210)),
                                ),
                                labelStyle: TextStyle(color: Colors.white),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid area';
                                }
                                final double parsedValue =
                                    double.tryParse(value) ?? 0;
                                if (parsedValue <= 0) {
                                  return 'Please enter a number greater than 0';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                area = value!;
                              },
                              style: TextStyle(
                                color:
                                    Colors.white, // Set the color of text input
                                fontWeight:
                                    FontWeight.bold, // Make the text bold
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          ElevatedButton(
// Inside the onPressed callback of the ElevatedButton
                            onPressed: () async {
                              setState(() {
                                // Set isFetching to true when starting to fetch forecast values
                                isFetching = true;
                              });

                              await costEstimate();
                              setState(() {
                                // Set isCostEstimated to true after the button is pressed
                                isCostEstimated = true;
                                isFetching = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 50,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:
                                  Color.fromARGB(200, 189, 183, 107),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            child: Text(
                              'Estimate Cost',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        
                          Visibility(
                            visible: isCostEstimated &&
                                !isFetching, // Show the container only if isCostEstimated is true and isFetching is false
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(
                                    0.01), // Add background color with opacity
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: widgets.map((widget) {
                                  if (widget is Text && widget.data != null) {
                                    return Text(
                                      widget.data!, // Get the text data
                                      style: TextStyle(
                                        fontSize:
                                            12.8, // Reduce the font size as needed
                                        color: Color.fromARGB(255, 251, 243,
                                            210), // Set the font color to white
                                      ),
                                    );
                                  } else {
                                    return widget;
                                  }
                                }).toList(),
                              ),
                            ),
                          ),
// Add a CircularProgressIndicator while fetching forecast values
                          // Add a CircularProgressIndicator while fetching forecast values
                          Visibility(
                            visible: isFetching,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors
                                    .white), // Set the color of the CircularProgressIndicator to white
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),  
            ],
          ),
        ),
      ),
    );
  }
}
