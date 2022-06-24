import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:gas_driver/models/driver_model.dart';
import 'package:gas_driver/models/user_model.dart';
import 'package:gas_driver/providers/location_provider.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  DriverModel? _driver;
  DriverModel? get driver => _driver;

  Future<void> login(String email, String password) async {
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get()
        .then((value) {
      _user = UserModel.fromJson(value);
    });
    await getCurrentUser();

    notifyListeners();
  }

  Future<void> signup(
      UserModel userModel, File profileFile, String plateNumber) async {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: userModel.email!, password: userModel.password!);

    userModel.userId = userCredential.user!.uid;

    final upload = await FirebaseStorage.instance
        .ref('profile_images/${userModel.userId}')
        .putFile(profileFile);

    final profileUrl = await upload.ref.getDownloadURL();

    userModel.profilePic = profileUrl;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set(userModel.toJson());

    //TODO: ADD USER TO NEARBY DRIVERS COLLECTION

    await FirebaseFirestore.instance
        .collection('drivers')
        .doc(userCredential.user!.uid)
        .set({
      'user': userModel.toJson(),
      'isAvailable': true,
      'plateNumber': plateNumber.toUpperCase(),
      'revenue': 0,
      'rating': 0,
      'numOfOrders': 0,
    });

    await getCurrentUser();
    notifyListeners();
  }

  Future<void> getCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      return UserModel.fromJson(value);
    });
    await FirebaseFirestore.instance
        .collection('drivers')
        .doc(userData.userId!)
        .set({
      'userId': userData.userId,
      'isAvailable': true,
      'plateNumber': 'KMCT 2001'.toUpperCase(),
      'revenue': 0,
      'rating': 0,
      'numOfOrders': 0,
    });

    final locs = await getUserLocations();

    userData.locations = locs;

    if (userData.isDriver!) {
      final driverData = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(uid)
          .get()
          .then((value) {
        return DriverModel.fromJson(value);
      });
      driverData.user = userData;
      _driver = driverData;
    }

    _user = userData;

    notifyListeners();
  }

  Future<List<UserLocation>> getUserLocations() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final locations = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('locations')
        .get();

    List<UserLocation> locationData = [];

    for (var doc in locations.docs) {
      locationData.add(
        await getLocationDetails(
          LatLng(doc['location'].latitude, doc['location'].longitude),
        ),
      );
    }

    return locationData;
  }

  Future<UserLocation> getLocationDetails(LatLng loc) async {
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: loc.latitude,
        longitude: loc.longitude,
        googleMapApiKey: "AIzaSyDIL1xyrMndlk2dSSSSikdobR8qDjz0jjQ");

    return UserLocation(
      city: data.city,
      country: data.country,
      street: data.street_number,
      postalCode: data.postalCode,
      address: data.address,
      state: data.state,
      location: LatLng(loc.latitude, loc.longitude),
    );
  }

  void setTransitId(String? id) {
    if (id == null) {
      _user!.transitId = null;
    } else {
      _user!.transitId = id;
    }
    notifyListeners();
  }

  void setDriverAvailability(bool isAvailable) {
    _driver!.isAvailable = isAvailable;
    notifyListeners();
  }
}
