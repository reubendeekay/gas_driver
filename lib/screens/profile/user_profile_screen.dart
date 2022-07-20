import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';
import 'package:gas_driver/helpers/lists.dart';
import 'package:gas_driver/providers/auth_provider.dart';
import 'package:gas_driver/providers/driver_provider.dart';
import 'package:gas_driver/screens/auth/login.dart';
import 'package:gas_driver/screens/profile/widgets/delivery_status_tile.dart';
import 'package:gas_driver/screens/profile/widgets/profile_stat_card.dart';
import 'package:gas_driver/screens/profile/widgets/settings_widget.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int selectedDeliveryStatus = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed((Duration.zero), () async {
      final driver = Provider.of<AuthProvider>(context, listen: false).driver!;

      setState(() {
        if (driver.isAvailable!) {
          selectedDeliveryStatus = 1;
        }
      });

      await Provider.of<AuthProvider>(context, listen: false).getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final driver = Provider.of<AuthProvider>(context, listen: false).driver!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: ProfileStatCard(
                  color: Colors.green[900]!,
                  secondaryColor: Colors.green[200],
                  value: driver.revenue!.toStringAsFixed(2),
                )),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: ProfileStatCard(
                  label: 'Orders',
                  value: driver.numOfOrders!.toString(),
                  color: Colors.blue[900]!,
                  secondaryColor: Colors.blue[200],
                  icon: Icons.shopping_bag_outlined,
                )),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                    child: ProfileStatCard(
                  color: Colors.purple[900]!,
                  secondaryColor: Colors.purple[200],
                  label: 'Tips',
                  value: '0',
                  icon: Icons.credit_score_sharp,
                )),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: ProfileStatCard(
                  color: Colors.pink[900]!,
                  secondaryColor: Colors.pink[200],
                  label: 'Rating',
                  value: driver.rating!.toStringAsFixed(1),
                  icon: Icons.star_half,
                )),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Delivery',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: List.generate(
                  deliveryStatus.length,
                  (index) => GestureDetector(
                        onTap: () async {
                          setState(() {
                            selectedDeliveryStatus = index;
                          });
                          await Provider.of<DriverProvider>(context,
                                  listen: false)
                              .setDriverAvailability(index == 1, context);
                        },
                        child: DeliveryStatusCard(
                            isSelected: selectedDeliveryStatus == index,
                            status: deliveryStatus[index]),
                      )),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Settings',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 15,
            ),
            const SettingsWidget(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Get.offAll(() => const LoginScreen());
                  },
                  color: kIconColor,
                  textColor: Colors.white,
                  child: const Text('Logout')),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
