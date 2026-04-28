import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dine_a_tap/screens/home_pages/reusables.dart';
import 'package:http/http.dart' as http;

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  bool _isLoading = true;
  // ignore: prefer_typing_uninitialized_variables
  String? apiKey = dotenv.env['API_KEY'];
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null) {
        String uid = user.uid;
        var userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (userDoc.exists) {
          String apiUrl =
              'https://api.autoinnovationtech.in/canteen/transaction_fetch.php?access_key=$apiKey&uid=$uid'; // Construct API URL
          var response = await http.get(Uri.parse(apiUrl)); // Make GET request
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            setState(() {
              transactions = jsonResponse;
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _isLoading = true;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  double? heightadjust() {
    if (transactions.length <= 2) {
      return MediaQuery.of(context).size.height / 1.3;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(155.0),
          child: CustomAppBar(
            title: 'Transactions',
            leftIcon: 'menu',
            rightIcon: 'shop',
          ),
        ),
        drawer: const CustomDrawer(),
        body: RefreshIndicator(
          onRefresh: () async {
            _fetchUserData();
          },
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(246, 241, 241, 100)),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 45),
                      child: Container(
                        height: heightadjust(),
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
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: transactions.isEmpty
                                  ? 1
                                  : transactions.length,
                              itemBuilder: (context, index) {
                                if (transactions.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.only(
                                        top: 80,
                                        bottom: 80,
                                        right: 25,
                                        left: 40),
                                    child: Center(
                                      child: Text(
                                        'Data Not Found!',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                var reversedTransactions =
                                    transactions.reversed.toList();
                                var transaction = reversedTransactions[index];
                                var amount = transaction['total'];
                                var items = transaction['items'];
                                var tokenId = transaction['token'];
                                var timestamp = transaction['time'] +
                                    " , " +
                                    transaction['date'];
                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(width: 1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Card(
                                      elevation: 0,
                                      shadowColor: Colors.black,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 5),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: 'Time :',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontFamily: 'Gothic A1',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ' $timestamp',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontFamily: 'Gothic A1',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: 'Amount :',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontFamily: 'Gothic A1',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ' ₹$amount',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontFamily: 'Gothic A1',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text.rich(
                                              TextSpan(children: [
                                                const TextSpan(
                                                  text: 'Token Number : ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22,
                                                    fontFamily: 'Gothic A1',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' $tokenId',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22,
                                                    fontFamily: 'Gothic A1',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ]),
                                            ),
                                            const SizedBox(height: 8),
                                            Text.rich(
                                              TextSpan(children: [
                                                const TextSpan(
                                                  text: 'Items : ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22,
                                                    fontFamily: 'Gothic A1',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' $items',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22,
                                                    fontFamily: 'Gothic A1',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ]),
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }
}
