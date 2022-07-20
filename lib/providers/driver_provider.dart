import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gas_driver/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class DriverProvider with ChangeNotifier {
  Future<Map> getComlpetedTasks() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ordersRef =
        FirebaseFirestore.instance.collection('requests/common/drivers');

    final allOrders = await ordersRef.where('driver', isNull: false).get();
    final commpleted = allOrders.docs
        .where((element) => element['driver']['userId'] == uid)
        .length;
    final lastWeekOrders = allOrders.docs
        .where((element) => element['createdAt']
            .toDate()
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .length;

    final myLastWeekOrders = allOrders.docs
        .where((element) =>
            element['driver']['userId'] == uid &&
            element['createdAt']
                .toDate()
                .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .length;

    return {
      'allOrders': allOrders.docs.length,
      'completed': commpleted,
      'lastWeekOrders': lastWeekOrders,
      'myLastWeekOrders': myLastWeekOrders,
    };
  }

  Future<List<Map<String, dynamic>>> getDailyCompletedTasks() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ordersRef =
        FirebaseFirestore.instance.collection('requests/common/drivers');
    List dayOfWeekLIst = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    //Get daily orders for the last week
    final allOrders = await ordersRef.where('driver', isNull: false).get();
    final List<Map<String, dynamic>> daysOrder = [];

    for (int day = 0; day < 7; day++) {
      final dayData = allOrders.docs
          .where((element) =>
              element['driver']['userId'] == uid &&
              element['createdAt']
                  .toDate()
                  .isAfter(DateTime.now().subtract(Duration(days: day))))
          .length;
      daysOrder.add(
        {'domain': dayOfWeekLIst[day], 'measure': dayData},
      );
    }

    return daysOrder;
  }

  Future<void> setDriverAvailability(
      bool isAvailable, BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    Provider.of<AuthProvider>(context, listen: false)
        .setDriverAvailability(isAvailable);
    final driverRef = FirebaseFirestore.instance.collection('drivers').doc(uid);
    await driverRef.update({'isAvailable': isAvailable});

    notifyListeners();
  }
}
