import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_driver/models/request_model.dart';
import 'package:gas_driver/providers/location_provider.dart';
import 'package:gas_driver/providers/request_provider.dart';
import 'package:gas_driver/screens/trail/widgets/customer_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker_icon/marker_icon.dart';
import 'package:provider/provider.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';

class TrailScreen extends StatefulWidget {
  const TrailScreen({Key? key, required this.requestId}) : super(key: key);
  final String requestId;

  @override
  State<TrailScreen> createState() => _TrailScreenState();
}

class _TrailScreenState extends State<TrailScreen> {
  GoogleMapController? _controller;

  Set<Marker> _markers = <Marker>{};
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
//Polyline patterns
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  _addPolyline(List<LatLng> _coordinates) {
    PolylineId id = const PolylineId("1");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: patterns[0],
        color: Colors.blueAccent,
        points: _coordinates,
        width: 10,
        onTap: () {});

    setState(() {
      _polylines[id] = polyline;
    });
  }

//google cloud api key
  GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: "AIzaSyDIL1xyrMndlk2dSSSSikdobR8qDjz0jjQ");

  void _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    // String value = await DefaultAssetBundle.of(context)
    //     .loadString('assets/map_style.json');
    // _controller!.setMapStyle(value);
    final loc =
        Provider.of<LocationProvider>(context, listen: false).locationData!;

    final request = await Provider.of<RequestProvider>(context, listen: false)
        .getRequestDetails(widget.requestId);

    _markers.addAll([
      Marker(
        markerId: const MarkerId('driver'),
        onTap: () {},
        //circle to show the mechanic profile in map
        icon: await MarkerIcon.downloadResizePicture(
            url:
                'https://i.pinimg.com/originals/79/64/83/796483ae19e58f77dafca3e5d4f3e06e.png',
            imageSize: 80
            // size: (100).toInt(),
            // borderSize: 10,
            // addBorder: true,
            // borderColor: kPrimaryColor
            ),
        position: LatLng(loc.latitude!, loc.longitude!),
      ),
      Marker(
        markerId: const MarkerId('customer'),
        onTap: () {},
        //circle to show the mechanic profile in map
        icon: await MarkerIcon.downloadResizePicture(
            url: request.user!.profilePic!, imageSize: 80
            // size: (100).toInt(),
            // borderSize: 10,
            // addBorder: true,
            // borderColor: kPrimaryColor
            ),
        position: LatLng(
            request.userLocation!.latitude, request.userLocation!.longitude),
      ),
    ]);
    var coordinates = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(loc.latitude!, loc.longitude!),
        destination: LatLng(
            request.userLocation!.latitude, request.userLocation!.longitude),
        mode: RouteMode.driving);
    _addPolyline(coordinates!);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final loc =
        Provider.of<LocationProvider>(context, listen: false).locationData!;

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('requests')
              .doc('common')
              .collection('drivers')
              .doc(widget.requestId)
              .snapshots(),
          builder: (context, snapshot) {
            return Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  markers: _markers,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  polylines: _polylines.values.toSet(),
                  myLocationButtonEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(loc.latitude!, loc.longitude!), zoom: 18),
                ),
                if (snapshot.hasData)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CustomerWidget(
                      request: RequestModel.fromJson(snapshot.data),
                    ),
                  )
              ],
            );
          }),
    );
  }
}
