import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';

class OnDeliveryTile extends StatelessWidget {
  const OnDeliveryTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
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
    );
  }
}
