import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:gas_driver/models/user_model.dart';
import 'package:gas_driver/providers/location_provider.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

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

  Future<void> signup(UserModel userModel) async {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: userModel.email!, password: userModel.password!);

    userModel.userId = userCredential.user!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set(userModel.toJson());

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
    final locs = await getUserLocations();

    userData.locations = locs;
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
}
