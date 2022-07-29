import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/widgets.dart';
import 'package:gas_driver/models/request_model.dart';
import 'package:gas_driver/models/user_model.dart';
import 'package:gas_driver/providers/auth_provider.dart';
import 'package:gas_driver/providers/notifications_provider.dart';
import 'package:get/route_manager.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class RequestProvider with ChangeNotifier {
  final notification = NotificationsProvider();

  Future<void> sendDriverAcceptance(RequestModel request, UserModel driver,
      LatLng driverInitialLocation, BuildContext context) async {
    final checkRequest = await FirebaseFirestore.instance
        .collection('requests')
        .doc('users')
        .collection(request.user!.userId!)
        .doc(request.id!)
        .get()
        .then((value) => RequestModel.fromJson(value));
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (checkRequest.driver == null) {
//TO USER REQUEST POOL
      await FirebaseFirestore.instance
          .collection('requests')
          .doc('users')
          .collection(request.user!.userId!)
          .doc(request.id!)
          .update({
        'driver': driver.toJson(),
        'driverLocation': GeoPoint(
            driverInitialLocation.latitude, driverInitialLocation.longitude),
        'status': 'driver found',
      });
//TO SPECIFIC PROVIDER REQUEST POOL
      await FirebaseFirestore.instance
          .collection('requests')
          .doc('providers')
          .collection(request.products!.first.ownerId!)
          .doc(request.id!)
          .update({
        'driver': driver.toJson(),
        'driverLocation': GeoPoint(
            driverInitialLocation.latitude, driverInitialLocation.longitude),
        'status': 'driver found',
      });
//TO COMMON POOL FOR NEARBY DRIVERS
      await FirebaseFirestore.instance
          .collection('requests')
          .doc('common')
          .collection('drivers')
          .doc(request.id!)
          .update({
        'driver': driver.toJson(),
        'driverLocation': GeoPoint(
            driverInitialLocation.latitude, driverInitialLocation.longitude),
        'status': 'driver found',
      });

      //SET TRANSIT ID TO USER COLLECTION
      await FirebaseFirestore.instance
          .collection('users')
          .doc(request.user!.userId!)
          .update({
        'transitId': request.id!,
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(request.driver!.userId!)
          .update({
        'transitId': request.id!,
      });
      await FirebaseFirestore.instance.collection('drivers').doc(uid).update({
        'isAvailable': false,
      });

      Provider.of<AuthProvider>(context, listen: false)
          .setTransitId(request.id!);

      await notification.sendAcceptanceNotification(
        request,
      );
    } else {
      Get.snackbar('Order already taken',
          'Ooops!. Accept requests immediately you receive them. Better luck next time');
    }

    notifyListeners();
  }

  Future<void> completeRequest(
      RequestModel request, BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('requests')
        .doc('users')
        .collection(request.user!.userId!)
        .doc(request.id!)
        .update({
      'status': 'completed',
    });
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('providers')
        .collection(request.products!.first.ownerId!)
        .doc(request.id!)
        .update({
      'status': 'completed',
    });
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('common')
        .collection('drivers')
        .doc(request.id!)
        .update({
      'status': 'completed',
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(request.driver!.userId!)
        .update({
      'transitId': null,
    });

    request.status = 'completed';
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('completed')
        .collection(uid)
        .doc(request.id!)
        .set(request.toJson());

    await FirebaseFirestore.instance.collection('drivers').doc(uid).update({
      'revenue': FieldValue.increment(request.deliveryFee),
      'isAvailable': true,
      'numOfOrders': FieldValue.increment(1),
    });

    Provider.of<AuthProvider>(context, listen: false).setTransitId(null);
    await notification.sendCompletedNotification(request);

    Provider.of<AuthProvider>(context, listen: false).getCurrentUser();
    notifyListeners();
  }

  Future<void> arrivedAtDestination(
    RequestModel request,
  ) async {
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('users')
        .collection(request.user!.userId!)
        .doc(request.id!)
        .update({
      'status': 'arrived',
    });
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('providers')
        .collection(request.products!.first.ownerId!)
        .doc(request.id!)
        .update({
      'status': 'arrived',
    });
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('common')
        .collection('drivers')
        .doc(request.id!)
        .update({
      'status': 'arrived',
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(request.user!.userId!)
        .update({
      'transitId': null,
    });

    await notification.sendArrivedNotification(request);
    notifyListeners();
  }

  Future<RequestModel> getRequestDetails(String requestId) async {
    final results = await FirebaseFirestore.instance
        .collection('requests')
        .doc('common')
        .collection('drivers')
        .doc(requestId)
        .get();

    notifyListeners();
    return RequestModel.fromJson(results);
  }
}
