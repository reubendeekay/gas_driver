import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';

class ProfileStatCard extends StatelessWidget {
  const ProfileStatCard(
      {Key? key,
      this.icon,
      this.label,
      this.value,
      required this.color,
      this.secondaryColor})
      : super(key: key);
  final IconData? icon;
  final String? label;
  final String? value;
  final Color color;
  final Color? secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: secondaryColor ?? color.withOpacity(0.5),
              borderRadius: BorderRadius.circular(3)),
          child: Icon(
            icon ?? Icons.attach_money_sharp,
            size: 20,
            color: color,
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label ?? 'Revenue',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 2.5,
            ),
            Text(
              value ?? 'KES 2000',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        )
      ]),
    );
  }
}
