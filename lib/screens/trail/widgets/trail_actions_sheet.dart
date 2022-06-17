import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gas_driver/models/request_model.dart';
import 'package:gas_driver/providers/request_provider.dart';
import 'package:iconsax/iconsax.dart';

import 'package:provider/provider.dart';

void actionSheet(BuildContext context, RequestModel request) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext buildContext) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.fromLTRB(12, 0, 0, 8),
                    child: const Text("ACTIONS",
                        style: TextStyle(
                            letterSpacing: 0.3, fontWeight: FontWeight.bold))),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Iconsax.message,
                    size: 20,
                  ),
                  title: const Text(
                    "Message",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                  onTap: () async {},
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.call,
                    size: 20,
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();

                    await FlutterPhoneDirectCaller.callNumber(
                        request.user!.phone!);
                  },
                  title: const Text(
                    "Call",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                  onTap: () async {},
                  title: const Text(
                    "Cancel Request",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.cloud_upload_outlined,
                    size: 20,
                  ),
                  onTap: () async {
                    await Provider.of<RequestProvider>(context, listen: false)
                        .completeRequest(request, context);
                    Navigator.of(context).pop();
                  },
                  title: const Text(
                    "Complete Request",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.report_outlined,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  title: const Text(
                    "Report User",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
