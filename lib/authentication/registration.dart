import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'login.dart';

import 'package:google_fonts/google_fonts.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  String _registrationError = '';

  Future<void> _register() async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      setState(() {
        _registrationError = 'The Email is already in use or Invalid';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: Stack(
        children: [
          
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/1598244.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5), 
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), 
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/images/hay.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                     
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Get Started!',
                        style: GoogleFonts.notoSansArmenian(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.green,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40), // Add spacing below the heading
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15, // Increased font size
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.lightGreen),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(15),
                              right: Radius.circular(3),
                            ),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15, // Increased font size
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.lightGreen),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(15),
                              right: Radius.circular(3),
                            ),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade100
                              .withOpacity(0.5), // Adjust opacity here
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          minimumSize: Size(300, 50),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      Text('Or',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.amber.shade100.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          minimumSize: Size(300, 50),
                        ),
                        onPressed: () {
                          // Navigate to the login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),

                      if (_registrationError.isNotEmpty)
                        Text(
                          _registrationError,
                          style: TextStyle(color: Colors.white),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
