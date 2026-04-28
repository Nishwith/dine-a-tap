import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dine_a_tap/screens/home_pages/prebook_page.dart';
import 'package:dine_a_tap/screens/home_pages/recharge.dart';
import 'package:dine_a_tap/screens/home_pages/reusables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MenuViewList extends StatefulWidget {
  const MenuViewList({super.key});

  @override
  State<MenuViewList> createState() => _MenuViewListState();
}

class _MenuViewListState extends State<MenuViewList> {
  List<Map<String, dynamic>> items = [];
  Map<String, List<Map<String, dynamic>>> categoryMap = {};
  Map<String, int> quantityMap = {};
  double totalAmount = 0.0;

  String? apiKey = dotenv.env['API_KEY'];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  fetchItems() async {
    String apiUrl =
        "https://api.autoinnovationtech.in/canteen/menu_fetch.php?access_key=$apiKey&var=1";
    final uri = Uri.parse(apiUrl);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        items = List<Map<String, dynamic>>.from(data);
        organizeItemsByCategory();
      });
    }
  }

  void organizeItemsByCategory() {
    categoryMap.clear();
    for (var item in items) {
      final category = item['category'];
      if (!categoryMap.containsKey(category)) {
        categoryMap[category] = [];
      }
      categoryMap[category]?.add(item);
      quantityMap[item['item_id']] = 0;
    }
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;

    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        fetchItems();
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(155.0),
          child: CustomAppBar(
            title: 'Pre-Booking',
            leftIcon: 'menu',
            rightIcon: '',
          ),
        ),
        drawer: const CustomDrawer(),
        body: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                child: Text(
                  "MENU",
                  style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'Gothic A1',
                      color: Color.fromRGBO(20, 108, 148, 1),
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categoryMap.length,
                itemBuilder: (context, categoryIndex) {
                  final category = categoryMap.keys.toList()[categoryIndex];
                  final categoryItems = categoryMap[category] ?? [];
                  return ExpansionTile(
                    title: Text(capitalizeFirstLetter(category)),
                    children: categoryItems.map<Widget>((item) {
                      final int quantity = quantityMap[item['item_id']] ?? 0;
                      return ListTile(
                        title: Text(capitalizeFirstLetter(item['item_name'])),
                        subtitle: Text('Amount: ₹${item['amount']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (quantity > 0) {
                                  setState(() {
                                    quantityMap[item['item_id']] = quantity - 1;
                                    updateTotalAmount();
                                  });
                                }
                              },
                            ),
                            SizedBox(
                              width: 100.0,
                              child: TextField(
                                controller: TextEditingController(
                                    text: quantity.toString()),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  updateTotalAmount();
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  quantityMap[item['item_id']] = quantity + 1;
                                  updateTotalAmount();
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
                padding: const EdgeInsets.only(bottom: 20),
              ),
            ),
            buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget buildBottomBar() {
    return BottomAppBar(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text('Total Amount:'),
                Text(
                  ' ₹$totalAmount',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(20, 108, 148, 1),
              ),
              onPressed: bookOrder,
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Book',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String buildOrderString() {
    List<String> orderList = [];

    for (var item in items) {
      final int quantity = quantityMap[item['item_id']] ?? 0;
      int amount = int.tryParse(item['amount'] ?? '0') ?? 0;

      if (quantity > 0) {
        String orderItem =
            '${item['item_name']} X$quantity ${quantity * amount}';
        orderList.add(orderItem);
      }
    }
    String orderString = orderList.join(',');

    return orderString;
  }

  Future<void> sendtoAPI(String orderString) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user!.uid;
    String apiUrl =
        "https://api.autoinnovationtech.in/canteen/add_pre_order.php?uid=$uid&cart=$orderString&total_amt=$totalAmount&access_key=$apiKey";
    final uri = Uri.parse(apiUrl);
    final response = await http.get(uri);
    try {
      if (response.statusCode == 200 &&
          jsonDecode(response.body)["status"] == "success") {
        // ignore: use_build_context_synchronously
        return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Order Placed'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    const Center(
                      child: Icon(
                        Icons.check_circle,
                        size: 36,
                        color: Colors.green,
                      ),
                    ),
                    const Text('Your Order has been successfully Placed!'),
                    const SizedBox(height: 16.0),
                    Text(orderString.replaceAll(',', '\n')),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Order more'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PreBookPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(20, 108, 148, 1),
                  ),
                  child: const Text('View Orders'),
                ),
              ],
            );
          },
        );
        // ignore: use_build_context_synchronously
      } else {
        // ignore: use_build_context_synchronously
        return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Insufficient Balance!'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    const Center(
                      child: Icon(
                        Icons.warning,
                        size: 36,
                        color: Colors.red,
                      ),
                    ),
                    const Text('Your wallet is insufficient for this order.'),
                    const SizedBox(height: 16.0),
                    Text(orderString.replaceAll(',', '\n')),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Recharge()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(20, 108, 148, 1),
                  ),
                  child: const Text('Recharge Now'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Insufficient Balance!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Center(
                    child: Icon(
                      Icons.warning,
                      size: 36,
                      color: Colors.red,
                    ),
                  ),
                  const Text('Your wallet is insufficient for this order.'),
                  const SizedBox(height: 16.0),
                  Text(orderString.replaceAll(',', '\n')),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Recharge()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(20, 108, 148, 1),
                ),
                child: const Text('Recharge Now'),
              ),
            ],
          );
        },
      );
    }
  }

  void bookOrder() {
    String orderString = buildOrderString();
    if (orderString.isEmpty) {
      showSelectionErrorDialog();
    } else {
      showOrderConfirmationAlert(orderString);
    }
  }

  Future<void> showSelectionErrorDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Not Selected Anything"),
          content: const Text("Please select at least one item."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(20, 108, 148, 1),
              ),
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showOrderConfirmationAlert(String orderString) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Order'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                    'Are you sure you want to book the following items?'),
                const SizedBox(height: 16.0),
                Text(orderString.replaceAll(',', '\n')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                sendtoAPI(orderString);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(20, 108, 148, 1),
              ),
              child: const Text('Book'),
            ),
          ],
        );
      },
    );
  }

  void updateTotalAmount() {
    double total = 0.0;
    for (var item in items) {
      final int quantity = quantityMap[item['item_id']] ?? 0;
      final double amount = double.tryParse(item['amount'].toString()) ?? 0.0;
      total += quantity * amount;
    }

    setState(() {
      totalAmount = double.parse(total.toStringAsFixed(2));
    });
  }
}
