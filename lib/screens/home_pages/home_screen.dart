import 'package:carousel_slider/carousel_slider.dart';
import 'package:dine_a_tap/screens/home_pages/help.dart';
import 'package:dine_a_tap/screens/home_pages/menu_view.dart';
import 'package:dine_a_tap/screens/home_pages/prebook_page.dart';
import 'package:dine_a_tap/screens/home_pages/recharge.dart';
import 'package:dine_a_tap/screens/home_pages/reusables.dart';
import 'package:dine_a_tap/screens/home_pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> menuItems = [];
  List<Map<String, dynamic>> cartListItems = [];
  int currentMenuSlide = 0;
  int currentCardSlide = 0;
  @override
  void initState() {
    super.initState();
    checkForUpdate();
    menuItems = [
      {
        'itemName': "Biryani...!!!",
        'caption': "The Love at first bite.",
        'imgName': "biryani",
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MenuViewList()),
          );
        }
      },
      {
        'itemName': "Mango Juice...!!!",
        'caption': "Sweet touch of fresh Mangoes.",
        'imgName': "juice",
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MenuViewList()),
          );
        }
      },
      {
        'itemName': "Ice Creams...!!!",
        'caption': "Beat the summer heat with creamy ice creams.",
        'imgName': "icecream",
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MenuViewList()),
          );
        }
      },
    ];
    cartListItems = [
      {
        'itemName': "Get Your Dine-A-Tap Card",
        'caption':
            "Grab your Dine-A-Tap card at the stall for a seamless dining experience.",
        'button': "",
        'onTap': () {},
      },
      {
        'itemName': "Recharge",
        'caption': "Recharge to make your hassle free order.",
        'button': "Recharge",
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Recharge()),
          );
        },
      },
      {
        'itemName': "Place Your Order",
        'caption':
            "Select your desired food items and place your order hassle-free.",
        'button': "Order Now",
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MenuViewList()),
          );
        },
      },
      {
        'itemName': "Tap and Retrieve",
        'caption':
            "Head to the nearby kiosk, tap your card, and receive your token swiftly.",
        'button': "",
        'onTap': () {},
      },
      {
        'itemName': "Enjoy Your Meal",
        'caption':
            "Find your spot, relax, and indulge in your delicious meal, knowing your dining experience is made effortless Dine-A-Tap.",
        'button': "",
        'onTap': () {},
      },
    ];
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          update();
        }
      });
    }).catchError((e) {});
  }

  void update() async {
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                color: const Color.fromARGB(255, 255, 255, 255),
                iconSize: 34,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_bag),
                color: const Color.fromARGB(255, 0, 0, 0),
                iconSize: 34,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PreBookPage(),
                    ),
                  );
                },
              ),
            ],
            elevation: 0,
            backgroundColor: Colors.transparent,
            pinned: false,
            floating: false,
            centerTitle: true,
            expandedHeight: 230,
            flexibleSpace: const FlexibleSpaceBar(
              stretchModes: [StretchMode.blurBackground],
              background: Image(
                image: AssetImage("assets/images/home_appbar.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      autoPlay: true,
                      enableInfiniteScroll: false,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayInterval: const Duration(seconds: 2),
                      viewportFraction: 1,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentMenuSlide = index;
                        });
                      }),
                  items: menuItems.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return cardMenu(
                          item['itemName'],
                          item['caption'],
                          item['imgName'],
                          item['onTap'],
                        );
                      },
                    );
                  }).toList(),
                ),
                Center(
                  child: AnimatedSmoothIndicator(
                      activeIndex: currentMenuSlide,
                      count: menuItems.length,
                      effect: const ExpandingDotsEffect()),
                ),
                Center(
                  child: GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      gridItem("assets/images/orderNow.png", "Food Order", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PreBookPage()));
                      }),
                      gridItem("assets/images/transactions.png", "Transactions",
                          () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Transactions()));
                      }),
                      gridItem("assets/images/recharge.png", "Recharge", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Recharge()));
                      }),
                      gridItem("assets/images/help.png", "Help", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Help()));
                      }),
                    ],
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text("Effortless ordering steps",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gothic A1')),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                      autoPlay: true,
                      enableInfiniteScroll: false,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 600),
                      autoPlayInterval: const Duration(seconds: 2),
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,
                      aspectRatio: 1.6,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentCardSlide = index;
                        });
                      }),
                  items: cartListItems.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return cartList(
                          item['itemName'],
                          item['caption'],
                          item['button'],
                          item['onTap'],
                        );
                      },
                    );
                  }).toList(),
                ),
                Center(
                  child: AnimatedSmoothIndicator(
                      activeIndex: currentCardSlide,
                      count: cartListItems.length,
                      effect: const ExpandingDotsEffect()),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("TAP",
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.31),
                              fontSize: 40,
                              fontWeight: FontWeight.w900)),
                      Text("INTO EASE!",
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.31),
                              fontSize: 40,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Center(
                    child: Text(
                      "Made with ❤️ by AUTOINNOTECH",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container cardMenu(
      String item, String caption, String imgName, Function onTap) {
    return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(45, 148, 255, 1),
                  Color.fromRGBO(15, 46, 78, 1)
                ])),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    item,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Archivo Black'),
                  ),
                  const SizedBox(height: 5),
                  Text(caption,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontFamily: 'Gothic A1')),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      onTap();
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 18),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white),
                        child: const Text(
                          "ORDER NOW",
                          style: TextStyle(
                              fontFamily: 'Archivo Black', fontSize: 14),
                        )),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Image(
                  image: AssetImage("assets/images/$imgName.png"),
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ));
  }

  Container cartList(
      String item, String caption, String button, Function onTap) {
    return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(45, 148, 255, 1),
                  Color.fromRGBO(15, 46, 78, 1)
                ])),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                item,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'Gothic A1'),
              ),
              const SizedBox(height: 10),
              Text(caption,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'Gothic A1')),
              const SizedBox(height: 10),
              button.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        onTap();
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 18),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.white),
                          child: Text(
                            button,
                            style: const TextStyle(fontFamily: 'Archivo Black'),
                          )),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }

  Widget gridItem(String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image(
            image: AssetImage(imagePath),
            fit: BoxFit.contain,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
