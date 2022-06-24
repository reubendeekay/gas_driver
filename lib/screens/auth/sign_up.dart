import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';
import 'package:gas_driver/models/driver_model.dart';
import 'package:gas_driver/models/user_model.dart';
import 'package:gas_driver/providers/auth_provider.dart';
import 'package:gas_driver/screens/auth/login.dart';
import 'package:gas_driver/screens/home/homepage.dart';
import 'package:gas_driver/widgets/loading_screen.dart';
import 'package:gas_driver/widgets/my_nav.dart';
import 'package:gas_driver/widgets/my_text_field.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? email;
  String? password, fullName, phoneNumber, plateNumber;

  File? profileFile;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            SizedBox(
              height: size.height * .15,
            ),
            const Center(
                child: Text(
              'Register',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
            const SizedBox(
              height: 5,
            ),
            const Center(
              child: Text(
                'Enter your credentials to create your account',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  setState(() {
                    profileFile = File(result.files.first.path!);
                  });
                } else {
                  // User canceled the picker
                }
              },
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    )),
                child: profileFile != null
                    ? CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(profileFile!),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                            Icon(
                              Iconsax.camera,
                              size: 20,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Upload profile',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ]),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MyTextField(
              hintText: 'Full Name',
              prefixIcon: Icons.person_outline,
              onChanged: (val) {
                setState(() {
                  fullName = val;
                });
              },
            ),
            const SizedBox(
              height: 15,
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
              hintText: 'Phone Number',
              prefixIcon: Icons.call_outlined,
              onChanged: (val) {
                setState(() {
                  phoneNumber = val;
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
            const SizedBox(
              height: 15,
            ),
            MyTextField(
              hintText: 'Vehicle Plate Number',
              prefixIcon: Icons.motorcycle_outlined,
              onChanged: (val) {
                setState(() {
                  plateNumber = val;
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 45,
              margin: const EdgeInsets.symmetric(vertical: 15),
              width: double.infinity,
              child: RaisedButton(
                onPressed: () async {
                  final user = UserModel(
                    email: email,
                    fullName: fullName,
                    isProvider: false,
                    locations: [],
                    password: password,
                    phone: phoneNumber,
                    plateNumber: plateNumber,
                    isDriver: true,
                  );
                  // try {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .signup(user, profileFile!, plateNumber!);
                  Get.offAll(() => const InitialLoadingScreen());
                  // } catch (e) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text(e.toString()),
                  //     ),
                  //   );
                  // }
                },
                textColor: Colors.white,
                color: kIconColor,
                child: const Text('Register'),
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
            const SizedBox(
              height: 30,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Get.off(() => const LoginScreen());
                },
                child: RichText(
                    text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.black),
                        children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                            color: kIconColor,
                            decoration: TextDecoration.underline),
                      )
                    ])),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ]),
    );
  }
}
