import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gas_driver/models/request_model.dart';
import 'package:gas_driver/models/user_model.dart';
import 'package:gas_driver/providers/auth_provider.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class RequestProvider with ChangeNotifier {
  Future<void> sendDriverAcceptance(RequestModel request, UserModel driver,
      LatLng driverInitialLocation, BuildContext context) async {
    print(request.user!.userId!);
    print(request.toJson());
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

    Provider.of<AuthProvider>(context, listen: false).setTransitId(request.id!);

    notifyListeners();
  }

  Future<void> completeRequest(
      RequestModel request, BuildContext context) async {
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
        .doc(request.user!.userId!)
        .update({
      'transitId': null,
    });
    Provider.of<AuthProvider>(context, listen: false).setTransitId(null);
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
