import 'package:dine_a_tap/screens/home_pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dine_a_tap/screens/home_pages/reusables.dart';
import 'package:dine_a_tap/screens/user_verification/reset.dart';
import 'package:dine_a_tap/screens/user_verification/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  bool isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(155.0),
        child: CustomAppBar(
          title: 'Login',
        ),
      ),
      drawer: null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:
            const BoxDecoration(color: Color.fromRGBO(246, 241, 241, 100)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Center(
                child: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(Colors.transparent, BlendMode.color),
                  child: Image(
                    image: AssetImage(
                      'assets/images/login.png',
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: _emailTextController,
                        obscureText: false,
                        enableSuggestions: true,
                        autocorrect: true,
                        cursorColor: const Color.fromARGB(255, 0, 0, 0),
                        style: TextStyle(
                          color:
                              const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
                          fontSize: 20,
                          fontFamily: 'Gothic A1',
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(1),
                            fontSize: 20,
                            fontFamily: 'Gothic A1',
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: _passwordTextController,
                        obscureText: isObscured,
                        enableSuggestions: false,
                        autocorrect: false,
                        cursorColor: const Color.fromARGB(255, 0, 0, 0),
                        style: TextStyle(
                          color:
                              const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
                          fontSize: 20,
                          fontFamily: 'Gothic A1',
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isObscured = !isObscured;
                              });
                            },
                            icon: Icon(
                              isObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(1),
                            fontSize: 20,
                            fontFamily: 'Gothic A1',
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    forgotPassword(),
                    const SizedBox(
                      height: 15,
                    ),
                    firebaseUIButton(context, "Login", Icons.login, () {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text)
                          .then((value) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('email', _emailTextController.text);
                        prefs.setString(
                            'password', _passwordTextController.text);

                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      }).onError((error, stackTrace) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Invalid Password or User Id',
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
                                      'OK',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: Color(0xFF146C94),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      });
                    }),
                    const SizedBox(
                      height: 15,
                    ),
                    signUpOption(),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row forgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ResetPassword()));
          },
          child: const Text(
            "Forgot Password?     ",
            style: TextStyle(
                color: Color(0xFF1F2660), fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an Account?",
            style:
                TextStyle(fontSize: 18, color: Color.fromARGB(179, 0, 0, 0))),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(
                fontSize: 19,
                color: Color(0xFF1F2660),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
