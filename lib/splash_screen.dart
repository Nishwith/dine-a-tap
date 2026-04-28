import 'dart:async';
import 'package:dine_a_tap/screens/home_pages/home_screen.dart';
import 'package:dine_a_tap/screens/user_verification/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initialState();
  }

  Future<void> initialState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var password = prefs.getString('password');

    Widget initialScreen;
    if (email != null && password != null) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        initialScreen = const HomeScreen();
      } catch (e) {
        initialScreen = const SignIn();
      }
    } else {
      initialScreen = const SignIn();
    }
    Timer(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => initialScreen));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                image: const AssetImage("assets/images/logo.png"),
                width: MediaQuery.of(context).size.width / 1.25,
                height: MediaQuery.of(context).size.width / 1.25),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromRGBO(20, 108, 148, 1),
              ),
            )
          ],
        ),
      ),
    );
  }
}
