import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dine_a_tap/screens/home_pages/reusables.dart';
import 'package:dine_a_tap/screens/user_verification/signin.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(155.0),
          child: CustomAppBar(
            title: 'Reset',
            leftIcon: 'back',
          ),
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration:
                const BoxDecoration(color: Color.fromRGBO(246, 241, 241, 100)),
            child: SingleChildScrollView(
                child: Column(children: [
              const Center(
                child: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(Colors.transparent, BlendMode.color),
                  child: Image(
                    image: AssetImage(
                      'assets/images/signup.png',
                    ),
                  ),
                ),
              ),
              Container(
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
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 50),
                      child: Column(children: <Widget>[
                        const SizedBox(
                          height: 40,
                        ),
                        reusableTextField("Email", false, _emailTextController),
                        const SizedBox(
                          height: 40,
                        ),
                        firebaseUIButton(
                          context,
                          "Reset Password",
                          Icons.send,
                          () {
                            _resetPassword(context);
                          },
                        )
                      ])))
            ]))));
  }

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailTextController.text);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Password reset email sent successfully! Check your Mail.'),
          duration: Duration(seconds: 3),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SignIn()));
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User Not Found!'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
