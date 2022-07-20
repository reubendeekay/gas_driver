import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';
import 'package:gas_driver/models/request_model.dart';
import 'package:gas_driver/providers/request_provider.dart';
import 'package:gas_driver/screens/trail/widgets/trail_actions_sheet.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomerWidget extends StatelessWidget {
  const CustomerWidget({Key? key, required this.request}) : super(key: key);

  final RequestModel request;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(request.user!.profilePic!),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.user!.fullName!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2.5),
                  Text(
                    request.user!.phone!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
          const SizedBox(
            height: 5,
          ),
          Text(
            request.paymentMethod!,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'KES ${request.total!.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(children: [
                  const Text(
                    'Today',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 2.5,
                  ),
                  Text(
                    DateFormat('HH:mm a').format(request.createdAt!.toDate()),
                  )
                ]),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  actionSheet(context, request);
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[300]!, width: 1),
                          borderRadius: BorderRadius.circular(2)),
                      child: const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        size: 14,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'More',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: RaisedButton.icon(
                  onPressed: () async {
                    if (request.status.toLowerCase() == 'arrived') {
                      await Provider.of<RequestProvider>(context, listen: false)
                          .completeRequest(request, context);
                      Navigator.of(context).pop();
                    } else {
                      await Provider.of<RequestProvider>(context, listen: false)
                          .arrivedAtDestination(
                        request,
                      );
                    }
                  },
                  icon: const Icon(
                    Iconsax.activity,
                    size: 20,
                    color: Colors.white,
                  ),
                  textColor: Colors.white,
                  color: kIconColor,
                  label: Text(request.status.toLowerCase() == 'arrived'
                      ? 'Complete'
                      : 'Arrived'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
