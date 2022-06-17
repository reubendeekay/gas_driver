import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';
import 'package:gas_driver/providers/auth_provider.dart';
import 'package:gas_driver/screens/trail/trail_screen.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class OnDeliveryTile extends StatelessWidget {
  const OnDeliveryTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trailId =
        Provider.of<AuthProvider>(context, listen: false).user!.transitId;
    return GestureDetector(
      onTap: () {
        Get.to(() => TrailScreen(
              requestId: trailId!,
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: kIconColor.withOpacity(0.4)),
        child: Row(children: const [
          Icon(
            Icons.motorcycle_outlined,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            'You are on delivery',
            style: TextStyle(fontSize: 13),
          ),
          Spacer(),
          Text('GO TO ORDER',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        ]),
      ),
    );
  }
}
