import 'package:flutter/material.dart';
import 'package:gas_driver/screens/auth/sign_up.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

class UnauthorisedUserDialog extends StatefulWidget {
  const UnauthorisedUserDialog({Key? key}) : super(key: key);

  @override
  State<UnauthorisedUserDialog> createState() => _UnauthorisedUserDialogState();
}

class _UnauthorisedUserDialogState extends State<UnauthorisedUserDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 8), () {
      Get.offAll(() => const SignUpScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset('assets/lock.json'),
            ),
          ),
          const Text(
            'You are not authorised to access the app',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Login with your driver account\n or register to continue',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
