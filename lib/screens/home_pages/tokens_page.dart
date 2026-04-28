import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TokenPage extends StatefulWidget {
  const TokenPage({super.key});

  @override
  State<TokenPage> createState() => _TokenPageState();
}

class _TokenPageState extends State<TokenPage> {
  String? apiKey = dotenv.env['API_KEY'];
  late List<Map<dynamic, dynamic>>? items = [];

  @override
  void initState() {
    super.initState();
    fetchOrderIds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          fetchOrderIds();
        },
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: items?.isEmpty ?? true ? 1 : items!.length,
                    itemBuilder: (context, index) {
                      if (items?.isEmpty ?? true) {
                        return const Padding(
                          padding: EdgeInsets.only(
                              top: 80, bottom: 80, right: 25, left: 40),
                          child: Center(
                            child: Text(
                              'No Orders Found!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }
                      final itemSort = items?.reversed.toList();
                      var item = itemSort![index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1.0),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Card(
                            elevation: 4,
                            shadowColor: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order ID: ${item['order_id']}',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(20, 108, 148, 1),
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Amount: ₹${item['total_amount']}',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(20, 108, 148, 1),
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Items:  ${item['items']}',
                                    style: const TextStyle(
                                        color: Color.fromRGBO(20, 108, 148, 1),
                                        fontSize: 18),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Time: ${item['time']}',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(20, 108, 148, 1),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Date:  ${item['date']}',
                                    style: const TextStyle(
                                        color: Color.fromRGBO(20, 108, 148, 1),
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  fetchOrderIds() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user!.uid;
    String apiUrl =
        "https://api.autoinnovationtech.in/canteen/pre_order_fetch.php?uid=$uid&access_key=$apiKey";
    final uri = Uri.parse(apiUrl);
    final response = await http.get(uri);
    final body = response.body;
    if (response.body == "0") {
      setState(() {
        items = [];
      });
    } else {
      try {
        List<dynamic> data = json.decode(body);
        List<Map<dynamic, dynamic>> itemList =
            List<Map<dynamic, dynamic>>.from(data);
        setState(() {
          items = itemList;
        });
      } catch (e) {
        return e;
      }
    }
  }
}
