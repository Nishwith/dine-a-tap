import 'package:flutter/material.dart';
import 'package:dine_a_tap/screens/home_pages/booking_page.dart';
import 'package:dine_a_tap/screens/home_pages/reusables.dart';
import 'package:dine_a_tap/screens/home_pages/tokens_page.dart';

class PreBookPage extends StatefulWidget {
  const PreBookPage({super.key});

  @override
  State<PreBookPage> createState() => _PreBookPageState();
}

class _PreBookPageState extends State<PreBookPage> {
  @override
  void initState() {
    super.initState();
  }

  void dipose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(155.0),
          child: CustomAppBar(
            title: 'Pre-Booking',
            leftIcon: 'menu',
            rightIcon: '',
          ),
        ),
        drawer: CustomDrawer(),
        body: Column(
          children: [
            TabBar(
                indicatorColor: Color.fromRGBO(20, 108, 148, 1),
                labelColor: Color.fromRGBO(20, 108, 148, 1),
                tabs: [
                  Tab(
                      icon: Icon(
                        Icons.local_attraction_sharp,
                        color: Color.fromRGBO(20, 108, 148, 1),
                      ),
                      text: 'Booked Tokens'),
                  Tab(
                    icon: Icon(
                      Icons.shopping_bag,
                      color: Color.fromRGBO(20, 108, 148, 1),
                    ),
                    text: 'Pre-Book ',
                  ),
                ]),
            Expanded(
              child: TabBarView(
                children: [TokenPage(), BookingPage()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
