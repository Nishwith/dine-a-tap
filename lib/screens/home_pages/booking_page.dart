// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:dine_a_tap/screens/home_pages/menu_view.dart';
import 'package:dine_a_tap/screens/home_pages/recharge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dine_a_tap/screens/home_pages/prebook_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<Map<dynamic, dynamic>> items = [];
  late List<TextEditingController> quantityControllers = [];
  String? apiKey = dotenv.env['API_KEY'];

  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  void dipose() {
    super.dispose();
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
        List<Map<dynamic, dynamic>> selectedItems = [];

        for (int i = 0; i < items.length; i++) {
          final controller = quantityControllers[i];
          final quantity = int.tryParse(controller.text) ?? 0;

          if (quantity > 0) {
            selectedItems.add(items[i]);
          }
        }
        return AlertDialog(
          title: const Text('Confirm Order'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                    'Are you sure you want to book the following items?'),
                const SizedBox(height: 16.0),
                Scrollbar(
                  trackVisibility: true,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      dataRowHeight: 40,
                      horizontalMargin: 0,
                      columns: const [
                        DataColumn(label: Text('Item Name')),
                        DataColumn(label: Text('Quantity')),
                        DataColumn(label: Text('Total Price')),
                      ],
                      rows: selectedItems.map((item) {
                        final itemName = item['item_name'];
                        final controller =
                            quantityControllers[items.indexOf(item)];
                        final quantity = int.tryParse(controller.text) ?? 0;
                        final amount =
                            double.tryParse(item['amount'] ?? '0') ?? 0.0;
                        final totalPrice = quantity * amount;

                        return DataRow(cells: [
                          DataCell(Text(itemName)),
                          DataCell(Text(quantity.toString())),
                          DataCell(Text('₹$totalPrice')),
                        ]);
                      }).toList()
                        ..add(DataRow(cells: [
                          const DataCell(Text('Total Amount:')),
                          const DataCell(Text('')),
                          DataCell(Text('₹$totalAmount')),
                        ])),
                    ),
                  ),
                ),
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

  fetchItems() async {
    String apiUrl =
        "https://api.autoinnovationtech.in/canteen/menu_fetch.php?access_key=$apiKey&var=1";
    final uri = Uri.parse(apiUrl);
    final response = await http.get(uri);
    final body = response.body;
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(body);
      List<Map<dynamic, dynamic>> itemList =
          List<Map<dynamic, dynamic>>.from(data);
      quantityControllers =
          List.generate(itemList.length, (index) => TextEditingController());

      setState(() {
        items = itemList;
        quantityControllers = List.generate(itemList.length, (index) {
          return TextEditingController(text: '0');
        });
      });
    }
  }

  void updateTotalAmount() {
    double total = 0.0;
    for (int i = 0; i < items.length; i++) {
      int quantity = int.tryParse(quantityControllers[i].text) ?? 0;
      double amount = double.tryParse(items[i]['amount'] ?? '0') ?? 0.0;
      total += quantity * amount;
    }

    setState(() {
      totalAmount = total;
    });
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
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 20.0),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final controller = quantityControllers[index];
                  return ListTile(
                    title: Text(capitalizeFirstLetter(item['item_name'])),
                    subtitle: Text('Amount: ₹${item['amount']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            int quantity = int.tryParse(controller.text) ?? 0;
                            if (quantity > 0) {
                              setState(() {
                                controller.text = (quantity - 1).toString();
                                updateTotalAmount();
                              });
                            }
                          },
                        ),
                        SizedBox(
                          width: 100.0,
                          child: TextField(
                            controller: controller,
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
                            int quantity = int.tryParse(controller.text) ?? 0;
                            setState(() {
                              controller.text = (quantity + 1).toString();
                              updateTotalAmount();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            buildBottomBar(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          child: Container(
            height: 56,
            width: 120,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 2, 13, 18),
              borderRadius: BorderRadius.circular(26.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book,
                    color: Colors.white,
                    size: 25,
                  ),
                  Text(
                    ' Menu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MenuViewList()));
          },
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

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final controller = quantityControllers[i];

      int quantity = int.tryParse(controller.text) ?? 0;
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
            List<Map<dynamic, dynamic>> selectedItems = [];

            for (int i = 0; i < items.length; i++) {
              final controller = quantityControllers[i];
              final quantity = int.tryParse(controller.text) ?? 0;

              if (quantity > 0) {
                selectedItems.add(items[i]);
              }
            }
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
                    Scrollbar(
                      trackVisibility: true,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          horizontalMargin: 0,
                          dataRowHeight: 40,
                          columns: const [
                            DataColumn(label: Text('Item Name')),
                            DataColumn(label: Text('Quantity')),
                            DataColumn(label: Text('Total Price')),
                          ],
                          rows: selectedItems.map((item) {
                            final itemName = item['item_name'];
                            final controller =
                                quantityControllers[items.indexOf(item)];
                            final quantity = int.tryParse(controller.text) ?? 0;
                            final amount =
                                double.tryParse(item['amount'] ?? '0') ?? 0.0;
                            final totalPrice = quantity * amount;

                            return DataRow(cells: [
                              DataCell(Text(itemName)),
                              DataCell(Text(quantity.toString())),
                              DataCell(Text('₹$totalPrice')),
                            ]);
                          }).toList()
                            ..add(DataRow(cells: [
                              const DataCell(Text('Total Amount:')),
                              const DataCell(Text('')),
                              DataCell(Text('₹$totalAmount')),
                            ])),
                        ),
                      ),
                    ),
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
                    Navigator.of(context).pop();

                    Navigator.pushReplacement(
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
}
