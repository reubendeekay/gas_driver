import 'package:flutter/material.dart';
import 'package:gas_driver/screens/notifications/notifications_screen.dart';
import 'package:gas_driver/screens/profile/widgets/edit_profile_screen.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';

List<Map<String, dynamic>> deliveryStatus = [
  {
    'icon': Icons.offline_bolt_outlined,
    'title': 'Close for delivery',
    'status': 'off',
  },
  {
    'icon': Icons.motorcycle_outlined,
    'title': 'Open for delivery',
    'status': 'on',
  }
];

List<Map<String, dynamic>> settingOptions = [
  {
    'title': 'Edit Profile',
    'icon': Iconsax.profile_add,
    'color': Colors.blue[900],
    'secondaryColor': Colors.blue[200],
    'onTap': () {
      Get.to(() => const EditProfileScreen());
    }
  },
  {
    'title': 'Notifications',
    'icon': Iconsax.notification,
    'color': Colors.green[900],
    'secondaryColor': Colors.green[200],
    'onTap': () {
      Get.to(() => NotificationsScreen());
    }
  },
  {
    'title': 'About',
    'icon': Iconsax.info_circle,
    'color': Colors.red[900],
    'secondaryColor': Colors.red[200],
    'onTap': () {}
  },
];
