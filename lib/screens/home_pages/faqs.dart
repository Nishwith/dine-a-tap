import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dine_a_tap/screens/home_pages/reusables.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FAQsPage extends StatefulWidget {
  const FAQsPage({Key? key}) : super(key: key);

  @override
  State<FAQsPage> createState() => _FAQsPageState();
}

class _FAQsPageState extends State<FAQsPage> {
  late List<bool> _isOpen;
  late List<Faq> _faqs = [];
  String? apiKey = dotenv.env['API_KEY'];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _isOpen = List.filled(0, false);
    _fetchFAQs();
  }

  Future<void> _fetchFAQs() async {
    final response = await http.get(Uri.parse(
        'https://api.autoinnovationtech.in/canteen/faq_fetch.php?access_key=$apiKey'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['faq'];
      setState(() {
        _faqs = data
            .map((faq) => Faq(
                  question: faq['question'],
                  answer: faq['answer'],
                ))
            .toList();
        _isOpen = List.generate(_faqs.length, (_) => false);
      });
    } else {
      throw Exception('Failed to load FAQs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(155.0),
        child: CustomAppBar(
          leftIcon: 'menu',
          rightIcon: 'shop',
          title: 'FAQ`S',
        ),
      ),
      drawer: const CustomDrawer(),
      body: _faqs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(246, 241, 241, 100)),
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
                    padding: const EdgeInsets.only(top: 30.0, bottom: 50),
                    child: Center(
                      child: Column(
                        children: List.generate(_faqs.length, (index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _isOpen[index] = !_isOpen[index];
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3,
                                        color: const Color(0xFF146C94)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            _faqs[index].question,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: 'Gothic A1',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Transform.rotate(
                                        angle: _isOpen[index]
                                            ? -3.141592653589793
                                            : 0,
                                        child: const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 30,
                                          color: Color(0xFF146C94),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_isOpen[index])
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          39, 20, 107, 148),
                                      border: Border.all(
                                          width: 3,
                                          color: const Color(0xFF146C94)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        title: Text(
                                          _faqs[index].answer,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Gothic A1',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class Faq {
  final String question;
  final String answer;
  Faq({required this.question, required this.answer});
}
