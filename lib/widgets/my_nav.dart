import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';
import 'package:gas_driver/models/request_model.dart';
import 'package:gas_driver/providers/auth_provider.dart';
import 'package:gas_driver/providers/location_provider.dart';
import 'package:gas_driver/screens/home/homepage.dart';
import 'package:gas_driver/screens/orders/orders_screen.dart';
import 'package:gas_driver/screens/profile/user_profile_screen.dart';
import 'package:gas_driver/screens/trail/customer_request_dialog.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class MyBottomNav extends StatefulWidget {
  const MyBottomNav({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBar createState() => _BottomNavBar();
}

class _BottomNavBar extends State<MyBottomNav> {
  int _selectedScreenIndex = 0;

  late final List<Widget> _screens = const [
    Homepage(),
    OrdersScreen(),
    UserProfileScreen(),
  ];

  _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
    final driver = Provider.of<AuthProvider>(context, listen: false).driver!;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('requests/common/drivers')
              .where('status', isEqualTo: 'accepted')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isNotEmpty && driver.isAvailable!) {
                return Stack(
                  children: [
                    _screens[_selectedScreenIndex],
                    CustomerRequestDialog(
                        request: RequestModel.fromJson(snapshot.data!.docs[0])),
                  ],
                );
              }
            }
            return _screens[_selectedScreenIndex];
          }),
      bottomNavigationBar: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.fromBorderSide(
                BorderSide(color: Colors.grey[300]!, width: 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavBarIcon(
                  icon: Iconsax.home,
                  inactiveIcon: Iconsax.screenmirroring,
                  labelOnActive: true,
                  darkMode: false,
                  active: (_selectedScreenIndex == 0),
                  onClick: () => _selectScreen(0),
                ),
                NavBarIcon(
                  icon: Iconsax.truck,
                  inactiveIcon: Iconsax.truck,
                  labelOnActive: true,
                  darkMode: false,
                  active: (_selectedScreenIndex == 1),
                  onClick: () => _selectScreen(1),
                ),
                NavBarIcon(
                  icon: Iconsax.profile_2user,
                  inactiveIcon: Iconsax.profile_2user,
                  labelOnActive: true,
                  darkMode: false,
                  active: (_selectedScreenIndex == 2),
                  onClick: () => _selectScreen(2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarIcon extends StatelessWidget {
  final IconData icon;
  final IconData inactiveIcon;
  final String? label;
  final bool? labelOnActive;
  final bool darkMode;
  final bool active;
  final Function() onClick;

  const NavBarIcon({
    Key? key,
    required this.icon,
    this.label,
    this.labelOnActive,
    required this.darkMode,
    required this.active,
    required this.inactiveIcon,
    required this.onClick,
  }) : super(key: key);

  Color _activeOpacity() {
    Color color;
    if (active) {
      color = darkMode ? Colors.white : Colors.black;
    } else {
      color = darkMode ? Colors.white54 : Colors.black54;
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Column(
        children: [
          Container(
            height: 32,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: active ? kIconColor.withOpacity(0.3) : Colors.transparent,
            ),
            child: Icon(
              active ? icon : inactiveIcon,
              size: 24,
              color: _activeOpacity(),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          if (label != null)
            if (labelOnActive == null ||
                (labelOnActive == true && active == true))
              Text(
                label!,
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.5,
                  color: _activeOpacity(),
                  fontWeight: FontWeight.w700,
                ),
              ),
        ],
      ),
    );
  }
}
