import 'package:gas_driver/providers/location_provider.dart';

class UserModel {
  final String? fullName;
  String? userId;
  final String? email;
  final String? password;
  final String? phone;
  final bool? isProvider;
  final String? profilePic;
  final String? transitId;
  final String? plateNumber;
  List<UserLocation>? locations;

  UserModel(
      {this.fullName,
      this.email,
      this.password,
      this.phone,
      this.isProvider,
      this.transitId,
      this.plateNumber = 'KMFF 730P ',
      this.userId,
      this.locations,
      this.profilePic});

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': phone,
      'isProvider': false,
      'userId': userId,
      'profilePic':
          'https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
      'transitId': transitId,
      'plateNumber': plateNumber,
    };
  }

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      isProvider: json['isProvider'],
      userId: json['userId'],
      profilePic: json['profilePic'],
      transitId: json['transitId'],
      plateNumber: json['plateNumber'],
    );
  }
}
