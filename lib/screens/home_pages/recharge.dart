import 'dart:convert';
import 'dart:math';
import 'package:dine_a_tap/screens/home_pages/home_screen.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:dine_a_tap/screens/home_pages/recharge_hostory.dart';
import 'package:dine_a_tap/screens/home_pages/reusables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Recharge extends StatefulWidget {
  const Recharge({Key? key}) : super(key: key);

  @override
  State<Recharge> createState() => _RechargeState();
}

class _RechargeState extends State<Recharge> {
  String? apiKey = dotenv.env['API_KEY'];
  String? clientId = dotenv.env['CLIENT_ID'];
  String? sceretKey = dotenv.env['SCERET_KEY'];
  int balance = 0;
  late String rfidNum;
  bool _isLoading = false;
  bool userActive = false;
  String userMailId = '';
  String uid = '';
  String userPhoneNum = '';
  late int amountEntered;
  final TextEditingController amountText = TextEditingController();
  late CFPaymentGatewayService cfPaymentGatewayService;

  @override
  void initState() {
    super.initState();
    cfPaymentGatewayService = CFPaymentGatewayService();
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(155.0),
        child: CustomAppBar(
          title: 'Recharge',
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
                  color: Color.fromRGBO(246, 241, 241, 100),
                ),
                child: SingleChildScrollView(
                  child: userActive
                      ? Column(
                          children: <Widget>[
                            const Center(
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.transparent,
                                  BlendMode.color,
                                ),
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/rechargeImg.png',
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 20,
                                    ),
                                    child: Text(
                                      "Balance : ₹ $balance",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 32,
                                        fontFamily: 'Gothic A1',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, bottom: 15),
                                    child: Text(
                                      "Hey! Recharge your wallet",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontFamily: 'Gothic A1',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            width: 3,
                                            color: Color(0xFF146C94),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: amountText,
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                              255,
                                              0,
                                              0,
                                              0,
                                            ).withOpacity(1),
                                            fontFamily: 'Gothic A1',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: "Amount",
                                            labelText:
                                                "Enter the recharge Amount",
                                            labelStyle: TextStyle(
                                              color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0,
                                              ).withOpacity(1),
                                              fontFamily: 'Gothic A1',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  firebaseUIButton(
                                      context, 'Recharge', Icons.payment,
                                      () async {
                                    if (amountText.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("Enter the Amount!"),
                                        ),
                                      );
                                    } else if (!isNumeric(
                                        amountText.text.trim())) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Enter the valid Amount!"),
                                        ),
                                      );
                                    } else {
                                      amountEntered =
                                          int.tryParse(amountText.text)!;
                                      if (amountEntered < 50) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "You must Recharge the Wallet more than 50 Rupees"),
                                          ),
                                        );
                                      } else {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        try {
                                          var session = await createSession();
                                          if (session != null) {
                                            var cfWebCheckOut =
                                                CFWebCheckoutPaymentBuilder()
                                                    .setSession(session)
                                                    .build();
                                            cfPaymentGatewayService
                                                .doPayment(cfWebCheckOut);
                                          }
                                        } catch (e) {
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(content: Text('$e')),
                                          );
                                        }
                                      }
                                    }
                                  }),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 50,
                              bottom: 50,
                              left: 20,
                              right: 20,
                            ),
                            padding: const EdgeInsets.all(20),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 3,
                                  color: Color(0xFF146C94),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Sorry for your Inconvenience, Your in the process of RFID distribution',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Gothic A1',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: userActive
          ? GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RechargeHistory(),
                  ),
                );
              },
              child: Container(
                height: 75,
                width: 75,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  color: const Color.fromRGBO(20, 108, 148, 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      color: Colors.white,
                      size: 28,
                    ),
                    Text(
                      "History",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Future<void> _fetchUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null) {
        uid = user.uid;
        var userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        String apiUrl =
            "https://api.autoinnovationtech.in/canteen/rfid_check.php?uid=$uid";
        final uri = Uri.parse(apiUrl);
        final response = await http.get(uri);
        final body = response.body;
        if (response.statusCode == 200) {
          // ignore: unrelated_type_equality_checks
          if (body == "1" || body == 1) {
            rfidNum = body;
          } else {
            rfidNum = "0";
          }
        } else {
          rfidNum = "0";
        }

        if (userDoc.exists) {
          if (rfidNum == "0") {
            setState(() {
              userActive = false;
            });
          } else {
            userActive = true;
          }
          userMailId = userDoc.get('email');
          userPhoneNum = userDoc.get('phoneNum');
          String apiUrl =
              'https://api.autoinnovationtech.in/canteen/balance_fetch.php?access_key=$apiKey&uid=$uid';
          var response = await http.get(Uri.parse(apiUrl));
          if (response.statusCode == 200) {
            Map<dynamic, dynamic> jsonResponse = jsonDecode(response.body);
            if (jsonResponse['balance'] is int) {
              setState(() {
                balance = jsonResponse['balance'];
                _isLoading = false;
              });
            } else {
              setState(() {
                balance = 0;
                _isLoading = false;
              });
            }
          }
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User Not Found')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User Not Logged In')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<CFSession?> createSession() async {
    try {
      int generateRandomNumber() {
        Random random = Random();
        int min = 100000;
        int max = 999999;
        return min + random.nextInt(max - min);
      }

      String orderID = uid + generateRandomNumber().toString();
      final mySessionIDData = await createSessionID(orderID);

      var session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.PRODUCTION)
          .setOrderId(mySessionIDData["order_id"])
          .setPaymentSessionId(mySessionIDData["payment_session_id"])
          .build();
      return session;
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    return null;
  }

  Future<Map<String, dynamic>> createSessionID(String orderID) async {
    var headers = {
      'Content-Type': 'application/json',
      'X-Client-Secret': sceretKey ?? "",
      'X-Client-Id': clientId ?? "",
      'x-api-version': '2022-09-01',
      'accept': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('https://api.cashfree.com/pg/orders'));
    request.body = json.encode({
      "order_amount": amountEntered,
      "order_id": orderID,
      "order_currency": "INR",
      "customer_details": {
        "customer_id": uid,
        "customer_email": userMailId,
        "customer_phone": userPhoneNum,
      },
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      throw Exception('Failed to create session ID');
    }
  }

  void verifyPayment(String orderId) async {
    await recharge(
      amountEntered: amountEntered,
      transactionId: orderId,
    );
    setState(() {
      _isLoading = false;
    });

    amountText.clear();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment Successful')),
    );
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: ((context) => RechargeHistory(key: UniqueKey()))),
    );
  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction Failed')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: ((context) => HomeScreen(key: UniqueKey()))),
    );
  }

  Future<void> recharge({
    required int amountEntered,
    required String? transactionId,
  }) async {
    setState(() {
      _isLoading = true;
    });
    int? balanceAmount = balance;
    int updatedBalance = amountEntered + balanceAmount;
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user!.uid;
    var url =
        "https://api.autoinnovationtech.in/canteen/balance_update.php?access_key=$apiKey&uid=$uid&amt=$amountEntered&transaction_id=$transactionId&status=success";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    // ignore: non_constant_identifier_names
    final Json = json.decode(body);
    if (Json == "success") {
      String uid = user.uid;
      var userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
      userDoc.update({'balanceAmount': updatedBalance}).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction Successful')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction Falied')),
        );
      });
      amountText.clear();
    } else {}
    setState(() {
      _isLoading = false;
    });
  }
}

bool isNumeric(String str) {
  if (str.isEmpty) {
    return false;
  }
  final RegExp regex = RegExp(r'^[0-9]+$');
  return regex.hasMatch(str);
}
