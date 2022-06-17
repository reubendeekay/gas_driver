import 'package:flutter/material.dart';
import 'package:gas_driver/screens/orders/widgets/order_widget.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.grey[50],
        elevation: 0.5,
      ),
      body: ListView(
        children: List.generate(10, (index) => OrderWidget()),
      ),
    );
  }
}
