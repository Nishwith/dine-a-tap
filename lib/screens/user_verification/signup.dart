import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_a_tap/screens/home_pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dine_a_tap/screens/home_pages/reusables.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? apiKey = dotenv.env['API_KEY'];

  final List<String> _colleges = <String>['klh'];
  String? selectedCollege;
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _rollNumber = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(155.0),
          child: CustomAppBar(title: 'Sign Up', leftIcon: 'back'),
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration:
                const BoxDecoration(color: Color.fromRGBO(246, 241, 241, 100)),
            child: SingleChildScrollView(
                child: Column(
              children: [
                const Center(
                  child: ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.transparent, BlendMode.color),
                    child: Image(
                      image: AssetImage(
                        'assets/images/signup.png',
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 5,
                        offset: Offset(0, -5),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 50),
                      child: Column(children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField("Email", false, _emailTextController),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField("Roll Number", false, _rollNumber),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                            "Phone Number", false, _phoneNumController),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: DropdownButton<String>(
                            hint: const Text(
                              'Select College',
                              style: TextStyle(fontSize: 20),
                            ),
                            value: selectedCollege,
                            items: _colleges.map((String college) {
                              return DropdownMenuItem<String>(
                                value: college,
                                child: Text(
                                  college,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCollege = newValue;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                            "Password", true, _passwordTextController),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField("Confirm Password", true,
                            _confirmPasswordTextController),
                        const SizedBox(
                          height: 20,
                        ),
                        firebaseUIButton(context, "Sign Up", Icons.login,
                            () async {
                          bool validateEmail(String email) {
                            final RegExp emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              caseSensitive: false,
                              multiLine: false,
                            );

                            return emailRegex.hasMatch(email);
                          }

                          bool isValid = validateEmail(
                            _emailTextController.text,
                          );
                          if (_phoneNumController.text.length != 10) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Please Enter Valid Phone Number!',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        )),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color:
                                                Color.fromRGBO(20, 108, 148, 1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          } else if (!isValid) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title:
                                        const Text('Please Enter Valid Email!',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            )),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color:
                                                Color.fromRGBO(20, 108, 148, 1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          } else if (_passwordTextController.text.length < 8) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'The password should be more than 8 letters!',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        )),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color:
                                                Color.fromRGBO(20, 108, 148, 1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          } else if (_rollNumber.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'The Roll Number is must and should!',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        )),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color:
                                                Color.fromRGBO(20, 108, 148, 1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          } else if (selectedCollege!.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Select your College!',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        )),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color:
                                                Color.fromRGBO(20, 108, 148, 1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          } else if (_passwordTextController.text ==
                              _confirmPasswordTextController.text) {
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text,
                              );
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser?.uid)
                                  .set({
                                'phoneNum': _phoneNumController.text,
                                'email': _emailTextController.text,
                                'rollNumber': _rollNumber.text,
                                'college': selectedCollege,
                                'balanceAmount': 0,
                                'RFIDNum': "In-progress"
                              });
                              String apiUrl =
                                  "https://api.autoinnovationtech.in/canteen/add_user.php?uid=${FirebaseAuth.instance.currentUser?.uid}&email=${_emailTextController.text}&phn_num=${_phoneNumController.text}&roll_num=${_rollNumber.text}&clg=$selectedCollege&access_key=$apiKey";
                              final uri = Uri.parse(apiUrl);
                              final response = await http.get(uri);
                              final Map<String, dynamic> jsonResponse =
                                  json.decode(response.body);
                              if (jsonResponse["status"] == "success") {
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()));
                              }
                            } catch (error) {
                              return null;
                            }
                          } else {
                            _passwordTextController.clear();
                            _confirmPasswordTextController.clear();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Please Enter All Details Correctly',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          color: Color(0xFF146C94),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }),
                      ])),
                ),
              ],
            ))));
  }
}
