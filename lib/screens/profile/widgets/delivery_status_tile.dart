import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';

class DeliveryStatusCard extends StatelessWidget {
  const DeliveryStatusCard(
      {Key? key, required this.isSelected, required this.status})
      : super(key: key);

  final bool isSelected;

  final Map<String, dynamic> status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: isSelected ? kIconColor.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(children: [
        Icon(status['icon'],
            size: 20, color: isSelected ? Colors.green[900] : Colors.black),
        SizedBox(width: 8),
        Text(status['title'],
            style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.green[900] : Colors.black)),
      ]),
    );
  }
}
