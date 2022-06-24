import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_driver/providers/auth_provider.dart';
import 'package:gas_driver/providers/location_provider.dart';
import 'package:gas_driver/widgets/my_nav.dart';
import 'package:gas_driver/widgets/unauthorised_user.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({Key? key}) : super(key: key);

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await Provider.of<AuthProvider>(context, listen: false).getCurrentUser();

      final user = Provider.of<AuthProvider>(context, listen: false).user!;

      if (!user.isDriver!) {
        Get.to(() => const UnauthorisedUserDialog());
      } else {
        await Provider.of<LocationProvider>(context, listen: false)
            .getCurrentLocation();

        Get.offAll(() => const MyBottomNav());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 200,
                width: double.infinity,
                child: Lottie.asset('assets/rider.json')),
            const Text(
              'Loading...',
              style: TextStyle(fontSize: 16),
            ),
          ]),
    );
  }
}
