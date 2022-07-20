import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_driver/models/request_model.dart';
import 'package:gas_driver/screens/orders/widgets/order_widget.dart';
import 'package:gas_driver/widgets/loading_effect.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.grey[50],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('requests/common/drivers')
              .where('driver', isNull: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingEffect.getSearchLoadingScreen(context);
            }

            List<DocumentSnapshot> docs = snapshot.data!.docs
                .where((element) => element['driver']['userId'] == uid)
                .toList();

            return ListView(
              padding: EdgeInsets.zero,
              children: List.generate(
                  docs.length,
                  (index) => OrderWidget(
                        request: RequestModel.fromJson(docs[index]),
                        index: index + 1,
                      )),
            );
          }),
    );
  }
}
