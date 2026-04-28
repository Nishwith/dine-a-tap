import 'package:dine_a_tap/screens/home_pages/home_screen.dart';
import 'package:dine_a_tap/screens/home_pages/policies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dine_a_tap/screens/home_pages/faqs.dart';
import 'package:dine_a_tap/screens/home_pages/help.dart';
import 'package:dine_a_tap/screens/home_pages/prebook_page.dart';
import 'package:dine_a_tap/screens/home_pages/transaction_page.dart';
import 'package:dine_a_tap/screens/home_pages/recharge.dart';
import 'package:dine_a_tap/screens/user_verification/signin.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String leftIcon;
  final String rightIcon;
  final int cartItemCount;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.leftIcon = '',
    this.rightIcon = '',
    this.cartItemCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildLeftIcon() {
      switch (leftIcon) {
        case 'back':
          return IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        case 'menu':
          return Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              iconSize: 34,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          );
        default:
          return Container();
      }
    }

    Widget buildRightIcon() {
      switch (rightIcon) {
        case 'menu':
          return Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              iconSize: 34,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          );
        case 'shop':
          return IconButton(
            icon: const Icon(Icons.shopping_bag),
            color: Colors.white,
            iconSize: 34,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreBookPage(),
                ),
              );
            },
          );

        default:
          return Container();
      }
    }

    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage('assets/images/appbar.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: buildLeftIcon(),
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontFamily: 'Gothic A1',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          actions: [buildRightIcon()],
          centerTitle: true,
        ),
      ],
    );
  }
}

TextField reusableTextField(
    String text, bool isPasswordType, TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: const Color.fromARGB(255, 0, 0, 0),
    style: TextStyle(
      color: const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
      fontSize: 20,
      fontFamily: 'Gothic A1',
      fontWeight: FontWeight.w400,
    ),
    decoration: InputDecoration(
      labelText: text,
      labelStyle: TextStyle(
        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
        fontSize: 20,
        fontFamily: 'Gothic A1',
        fontWeight: FontWeight.w400,
      ),
      filled: false,
      floatingLabelBehavior: FloatingLabelBehavior.never,
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container firebaseUIButton(
    BuildContext context, String title, IconData icon, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width / 1.2,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      // ignore: sort_child_properties_last
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$title ",
            style: const TextStyle(
                color: Color.fromARGB(221, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          Icon(icon)
        ],
      ),
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return const Color(0xFF146C94);
            }
            return const Color(0xFF146C94);
          }),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white.withOpacity(1),
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 50,
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Color(0xFF146C94)),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: ListTile(
              title: const Text(
                'Home',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Gothic A1',
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Color(0xFF146C94)),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: ListTile(
              title: const Text(
                'Pre-Booking',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Gothic A1',
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreBookPage(),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Color(0xFF146C94)),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: ListTile(
              title: const Text(
                'Transactions',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Gothic A1',
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Transactions(),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Color(0xFF146C94)),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: ListTile(
              title: const Text(
                'Recharge',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Gothic A1',
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Recharge(),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Color(0xFF146C94)),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: ListTile(
              title: const Text(
                'Help & Request',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Gothic A1',
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Help(),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Color(0xFF146C94)),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: ListTile(
              title: const Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Gothic A1',
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FAQsPage(),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Color(0xFF146C94)),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: ListTile(
              title: const Text(
                'Policies',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Gothic A1',
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PoliciesPage(),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Color(0xFF146C94)),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: ListTile(
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Gothic A1',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Do you want to Logout?',
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
                                'Cancel',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Color.fromRGBO(20, 108, 148, 1),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.remove('email');
                                  prefs.remove('password');
                                  await FirebaseAuth.instance.signOut();
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignIn()));
                                } catch (e) {
                                  return;
                                }
                              },
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Color.fromRGBO(20, 108, 148, 1),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
