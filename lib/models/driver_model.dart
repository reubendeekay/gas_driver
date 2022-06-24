import 'package:gas_driver/models/user_model.dart';

class DriverModel {
  final String? userId;
  UserModel? user;
  bool? isAvailable;
  final String? plateNumber;
  final double? revenue;
  final double? rating;
  final int? numOfOrders;

  DriverModel({
    this.userId,
    this.isAvailable,
    this.plateNumber,
    this.revenue,
    this.rating,
    this.numOfOrders,
    this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': userId,
      'isAvailable': isAvailable,
      'plateNumber': plateNumber,
      'revenue': revenue,
      'rating': rating,
      'numOfOrders': numOfOrders,
    };
  }

  factory DriverModel.fromJson(dynamic json) {
    return DriverModel(
      userId: json['userId'],
      isAvailable: json['isAvailable'],
      plateNumber: json['plateNumber'],
      revenue: double.parse(json['revenue'].toString()),
      rating: double.parse(json['rating'].toString()),
      numOfOrders: json['numOfOrders'],
    );
  }
}
