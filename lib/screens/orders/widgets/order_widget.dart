import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';
import 'package:gas_driver/models/request_model.dart';
import 'package:gas_driver/screens/trail/trail_screen.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({Key? key, required this.request, required this.index})
      : super(key: key);
  final RequestModel request;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (request.status != 'completed') {
          Get.to(() => TrailScreen(requestId: request.id!));
        }
      },
      child: Container(
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
                Text(
                  'Order #$index',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text(
                  DateFormat('dd MMM, HH:mm a')
                      .format(request.createdAt!.toDate()),
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
                      request.user!.profilePic!,
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
                      Text(
                        request.products!.first.name!,
                      ),
                      const SizedBox(height: 2.5),
                      Row(
                        children: [
                          Text(
                            'KES ${request.total!.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                color: request.status == 'completed'
                                    ? kIconColor.withOpacity(0.5)
                                    : Colors.red[200]),
                            child: Text(
                              request.status == 'completed'
                                  ? 'Completed'
                                  : 'Ongoing',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: request.status == 'completed'
                                      ? kIconColor
                                      : Colors.red[900]),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('-' + request.user!.fullName!,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
