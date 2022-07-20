import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:gas_driver/models/notification_model.dart';
import 'package:gas_driver/models/request_model.dart';

class NotificationsProvider {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final userNotificationsRef = FirebaseFirestore.instance
      .collection('userData')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notifications');

  Future<void> sendAcceptanceNotification(RequestModel request) async {
    final userNotification = NotificationsModel(
      id: request.id,
      message:
          'You have accepted to delivery order ${request.id}. Please pick the order from the location to the user',
      imageUrl:
          'https://uploads-ssl.webflow.com/60edc0a8835d5b38bf11f03f/61cf085303a8eef996acbdd7_Purchase-Order-Procedure.jpeg',
      type: 'driver accepted',
      senderId: uid,
      createdAt: request.createdAt,
    );

    final providerNotification = NotificationsModel(
      id: request.id,
      message:
          'The order ${request.id} will be picked and delivered by ${request.driver!.fullName}',
      imageUrl:
          'https://img.freepik.com/premium-vector/map-with-destination-location-point-city-map-with-street-river-gps-map-navigator-concept_34645-1078.jpg?w=2000',
      type: 'driver accepted',
      senderId: uid,
      createdAt: request.createdAt,
    );

    final customerNotification = NotificationsModel(
      id: request.id,
      message:
          'Your delivery driver for ${request.id} is ${request.driver!.fullName}. Track the delivery progress on the app',
      imageUrl:
          'https://img.freepik.com/premium-vector/map-with-destination-location-point-city-map-with-street-river-gps-map-navigator-concept_34645-1078.jpg?w=2000',
      type: 'driver accepted',
      senderId: uid,
      createdAt: request.createdAt,
    );

    await userNotificationsRef.doc().set(userNotification.toJson());

    await FirebaseFirestore.instance
        .collection('userData')
        .doc(request.products!.first.ownerId!)
        .collection('notifications')
        .doc()
        .set(providerNotification.toJson());

    await FirebaseFirestore.instance
        .collection('userData')
        .doc(request.user!.userId!)
        .collection('notifications')
        .doc()
        .set(customerNotification.toJson());
  }

  Future<void> sendCompletedNotification(RequestModel request) async {
    final userNotification = NotificationsModel(
      id: request.id,
      message:
          'You have successfully delivered order ${request.id}. Please wait as we credit your account',
      imageUrl:
          'https://img.etimg.com/thumb/msid-91480863,width-650,imgsize-192030,,resizemode-4,quality-100/food-delivery-platform.jpg',
      type: 'delivered',
      senderId: uid,
      createdAt: request.createdAt,
    );
    print('STARTEEEEEEEEDÊ');

    final providerNotification = NotificationsModel(
      id: request.id,
      message:
          'The order ${request.id} has been  delivered by ${request.driver!.fullName} to ${request.user!.fullName}',
      imageUrl:
          'https://img.etimg.com/thumb/msid-91480863,width-650,imgsize-192030,,resizemode-4,quality-100/food-delivery-platform.jpg',
      type: 'delivered',
      senderId: uid,
      createdAt: request.createdAt,
    );

    final customerNotification = NotificationsModel(
      id: request.id,
      message:
          'Hurray!! Your order ${request.id} has been delivered. Thank you for choosing us',
      imageUrl:
          'https://img.etimg.com/thumb/msid-91480863,width-650,imgsize-192030,,resizemode-4,quality-100/food-delivery-platform.jpg',
      type: 'delivered',
      senderId: uid,
      createdAt: request.createdAt,
    );

    await userNotificationsRef.doc().set(userNotification.toJson());

    await FirebaseFirestore.instance
        .collection('userData')
        .doc(request.products!.first.ownerId!)
        .collection('notifications')
        .doc()
        .set(providerNotification.toJson());

    await FirebaseFirestore.instance
        .collection('userData')
        .doc(request.user!.userId!)
        .collection('notifications')
        .doc()
        .set(customerNotification.toJson());
  }

  Future<void> sendArrivedNotification(RequestModel request) async {
    final customerNotification = NotificationsModel(
      id: request.id,
      message:
          'Your delivery driver has arrived. Please meet him at the location to pick the order',
      imageUrl:
          'https://omniaccounts.co.za/wp-content/uploads/2021/09/5-Key-Benefits-of-Delivery-Management-Software.jpg',
      type: 'arrived',
      senderId: uid,
      createdAt: request.createdAt,
    );

    await FirebaseFirestore.instance
        .collection('userData')
        .doc(request.user!.userId!)
        .collection('notifications')
        .doc()
        .set(customerNotification.toJson());
  }
}
