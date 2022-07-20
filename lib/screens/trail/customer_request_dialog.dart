import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';
import 'package:gas_driver/models/request_model.dart';
import 'package:gas_driver/providers/auth_provider.dart';
import 'package:gas_driver/providers/location_provider.dart';
import 'package:gas_driver/providers/request_provider.dart';
import 'package:gas_driver/screens/trail/trail_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class CustomerRequestDialog extends StatefulWidget {
  const CustomerRequestDialog({Key? key, required this.request})
      : super(key: key);
  final RequestModel request;

  @override
  State<CustomerRequestDialog> createState() => _CustomerRequestDialogState();
}

class _CustomerRequestDialogState extends State<CustomerRequestDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          builder: (ctx) => Dialog(
                child: CustomerRequestWidget(request: widget.request),
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CustomerRequestWidget extends StatefulWidget {
  const CustomerRequestWidget({Key? key, required this.request})
      : super(key: key);
  final RequestModel request;

  @override
  State<CustomerRequestWidget> createState() => _CustomerRequestWidgetState();
}

class _CustomerRequestWidgetState extends State<CustomerRequestWidget> {
  bool isFinished = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user!;
    final loc =
        Provider.of<LocationProvider>(context, listen: false).locationData;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      widget.request.user!.profilePic!),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.request.user!.fullName!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2.5),
                    Text(
                      widget.request.user!.phone!,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
            Divider(),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 48,
              child: SwipeableButtonView(
                buttonText: 'Slide to Accept',
                buttonWidget: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                ),
                activeColor: kPrimaryColor,
                isFinished: isFinished,
                onWaitingProcess: () {
                  Future.delayed(const Duration(milliseconds: 10), () async {
                    final request = RequestModel(
                      driverLocation: GeoPoint(loc!.latitude!, loc.longitude!),
                      products: widget.request.products,
                      id: widget.request.id,
                      user: widget.request.user,
                      driver: user,
                      userLocation: widget.request.userLocation,
                      paymentMethod: widget.request.paymentMethod,
                      total: widget.request.total,
                    );

                    
                    await Provider.of<RequestProvider>(context, listen: false)
                        .sendDriverAcceptance(request, user,
                            LatLng(loc.latitude!, loc.longitude!), context);
                    setState(() {
                      isFinished = true;
                    });
                  });
                },
                onFinish: () async {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: TrailScreen(
                            requestId: widget.request.id!,
                          )));

                  setState(() {
                    isFinished = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
