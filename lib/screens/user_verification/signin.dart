import 'package:flutter/material.dart';
import 'package:dine_a_tap/screens/user_verification/login.dart';
import 'package:dine_a_tap/screens/user_verification/signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:
            const BoxDecoration(color: Color.fromRGBO(246, 241, 241, 100)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                      Colors.transparent, BlendMode.color),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48, bottom: 18),
                    child: Image(
                      image: const AssetImage(
                        'assets/images/index.png',
                      ),
                      height: MediaQuery.of(context).size.height / 2,
                    ),
                  ),
                ),
              ),
              const Center(
                  child: Column(
                children: [
                  Text(
                    'WELCOME',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontFamily: 'Archivo Black',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Dine A Tap',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontFamily: 'Gothic A1',
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              )),
              Center(
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        width: 300,
                        height: 60,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF146C94),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Create an Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        width: 300,
                        height: 60,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 3, color: Color(0xFF146C94)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF146C94),
                              fontSize: 20,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
