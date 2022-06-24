import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';
import 'package:gas_driver/providers/auth_provider.dart';
import 'package:gas_driver/screens/auth/sign_up.dart';
import 'package:gas_driver/screens/home/homepage.dart';
import 'package:gas_driver/widgets/loading_screen.dart';
import 'package:gas_driver/widgets/my_nav.dart';
import 'package:gas_driver/widgets/my_text_field.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            SizedBox(
              height: size.height * .25,
            ),
            const Center(
                child: Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
            const SizedBox(
              height: 5,
            ),
            const Center(
              child: Text(
                'Enter your credentials to access your account',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            SizedBox(
              height: size.height * .2,
              child: Lottie.asset('assets/courier.json'),
            ),
            MyTextField(
              hintText: 'Email',
              prefixIcon: Icons.email_outlined,
              onChanged: (val) {
                setState(() {
                  email = val;
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            MyTextField(
              hintText: 'Password',
              prefixIcon: Icons.lock_outline,
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              },
            ),
            Container(
              height: 45,
              margin: const EdgeInsets.symmetric(vertical: 15),
              width: double.infinity,
              child: RaisedButton(
                onPressed: () async {
                  try {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .login(email!, password!);
                    Get.offAll(() => const InitialLoadingScreen());
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                },
                textColor: Colors.white,
                color: kIconColor,
                child: const Text('Login'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'Forgot Password?',
                  style: TextStyle(color: kIconColor),
                ),
              ],
            ),
            SizedBox(
              height: size.height * .1,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Get.to(() => const SignUpScreen());
                },
                child: RichText(
                    text: const TextSpan(
                        text: 'Not a registered driver? ',
                        style: TextStyle(color: Colors.black),
                        children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                            color: kIconColor,
                            decoration: TextDecoration.underline),
                      )
                    ])),
              ),
            )
          ]),
    );
  }
}
