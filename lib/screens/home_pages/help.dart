// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:dine_a_tap/screens/home_pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:dine_a_tap/screens/home_pages/reusables.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final TextEditingController _textController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(155.0),
        child: CustomAppBar(
          title: 'Help',
          leftIcon: 'menu',
          rightIcon: 'shop',
        ),
      ),
      drawer: const CustomDrawer(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration:
            const BoxDecoration(color: Color.fromRGBO(246, 241, 241, 100)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 40),
          child: Container(
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
              padding: const EdgeInsets.only(top: 20.0, bottom: 50),
              child: Center(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Hey User ! Reach us',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Gothic A1',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Brief your problem',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Gothic A1',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: MediaQuery.of(context).size.width / 2.5,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 3, color: Color(0xFF146C94)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(4),
                                  border: InputBorder.none,
                                  hintText: 'Write your Problem in brief',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 30),
                        child: _isSubmitting
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF146C94),
                                ),
                              )
                            : firebaseUIButton(
                                context,
                                "Raise Ticket",
                                Icons.message,
                                () {
                                  _onRaisedTicketPressed(_textController.text);
                                },
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRaisedTicketPressed(String query) async {
    if (query.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill your queries.'),
      ));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User not logged in.'),
        ));
        return;
      }

      String uid = user.uid;
      CollectionReference queriesCollection =
          FirebaseFirestore.instance.collection('Queries');
      DocumentReference userDocRef = queriesCollection.doc();
      await userDocRef.set({
        'query': query,
        'timestamp': FieldValue.serverTimestamp(),
        'uid': uid,
      });
      String apiUrl =
          "https://api.autoinnovationtech.in/canteen/ticket_add.php?uid=$uid&ticket_text=$query";
      final uri = Uri.parse(apiUrl);
      final response = await http.get(uri);
      if (response.statusCode == 200 &&
          jsonDecode(response.body)["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ticket submitted successfully!'),
        ));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        throw Exception("Please try again!");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}
