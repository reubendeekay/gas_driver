import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
      padding: const EdgeInsets.all(15),
      height: 114,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order #1',
                style: TextStyle(fontSize: 12),
              ),
              const Text(
                '17 Jun, 11:00 AM',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox(
                  height: 60,
                  width: 100,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cooking Oil',
                    ),
                    const SizedBox(height: 2.5),
                    Row(
                      children: [
                        const Text(
                          'KES 180',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1),
                              color: kIconColor.withOpacity(0.5)),
                          child: const Text(
                            'Completed',
                            style: TextStyle(fontSize: 10, color: kIconColor),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text('-Reuben Jefwa',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
