import 'dart:async';

import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:provider/provider.dart';

import '../UserLocation/LocationProvider.dart';

class TrackBuyer extends StatefulWidget {
  final double Latitude;
  final double Longitude;
  final int phoneNumber;
   TrackBuyer({super.key, required this.Latitude, required this.Longitude,required this.phoneNumber});




  @override
  State<TrackBuyer> createState() => _TrackBuyerState();
}

class _TrackBuyerState extends State<TrackBuyer> {

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
 late BitmapDescriptor customMapIcon;
  //CREATE POLYLINE
  List<LatLng> _routes = [];
  Future<List<LatLng>> _getRoutes () async{
    final points = await Provider.of<LocationProvider> (context,listen: false).getRouteCoordinates(
        LatLng(Provider.of<LocationProvider> (context,listen: false).Lat, Provider.of<LocationProvider> (context,listen: false).Long),
        LatLng(widget.Latitude, widget.Longitude));
    setState(() {
      _routes = points;
    });
    return points;

  }

  //CUSTOM ICON FOR VENDOR LOCATION
  Future<BitmapDescriptor> _loadCustomIcon(BuildContext context) async {
    final ImageConfiguration configuration = createLocalImageConfiguration(context, size: const Size(40, 40));
    setState(() async {
      customMapIcon =  await BitmapDescriptor.asset(configuration, 'assets/Icon/profile.png');
    });
    return await BitmapDescriptor.asset(configuration, 'assets/Icon/profile.png');
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRoutes();
    _loadCustomIcon(context);
  }
  @override
  Widget build(BuildContext context) {
    _getRoutes();
    _loadCustomIcon(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
    title: RichText(text: TextSpan(
        children: [
        TextSpan(text: "Tracking ", style: TextStyle(color: Colors.black, fontSize: 20.sp,fontFamily: 'Righteous',)),
    TextSpan(text: "Buyer...", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.sp,fontFamily: 'Righteous',)),

    ]
    )),
    centerTitle: true,
    ),
         body: Badge(
           alignment: Alignment.topLeft,
           label: Padding(
             padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
             child: GestureDetector(
               onTap: () async{
                 await EasyLauncher.call(number: widget.phoneNumber.toString());
               },
               child: Row(
                 children: [
                   Icon(Icons.phone, color: Colors.white,),
                   Text('  Tap to call Receiver : 0${widget.phoneNumber}  ', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10.sp,fontFamily: 'Righteous',),),
                 ],
               ),
             ),
           ),
           child: Center(
             child: FutureBuilder(
                 future: Provider.of<LocationProvider>(context,
                     listen: false)
                     .determinePosition(),
                 builder: (context, snapshot) {
                   if (snapshot.hasData) {
                     return GoogleMap(
                       polylines: {
                         Polyline(
                             polylineId: PolylineId('route'),
                             visible: true,
                             points: _routes,
                             color: Colors.blue,
                             width: 4),
                       },
                       gestureRecognizers: Set.from(
                         [
                           Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
                           Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
                           Factory<HorizontalDragGestureRecognizer>(() => HorizontalDragGestureRecognizer()),
                           Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
                           Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
                           Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                         ],
                       ),
                       markers: {
                         Marker(

                           icon: customMapIcon,
                             markerId: MarkerId('User'),
                             visible: true,
                             position: LatLng(
                                 widget.Latitude,
                                 widget.Longitude)),

                       },
                       circles: Set(),
                       mapToolbarEnabled: true,
                       padding: EdgeInsets.all(12),
                       scrollGesturesEnabled: true,
                       zoomControlsEnabled: true,
                       myLocationEnabled: true,
                       myLocationButtonEnabled: true,
                       mapType: MapType.normal,
                       onMapCreated:  (GoogleMapController controller) {
                         _controller.complete(_controller
                         as FutureOr<GoogleMapController>?);
                       },
                       initialCameraPosition: CameraPosition(
                         bearing: 192.8334901395798,
                         target: LatLng(
                             Provider.of<LocationProvider>(
                                 context,
                                 listen: false)
                                 .Lat,
                             Provider.of<LocationProvider>(
                                 context,
                                 listen: false)
                                 .Long),
                         tilt: 9.440717697143555,
                         zoom: 11.151926040649414,
                       ),
                     );
                   }
                   return Center( child: CustomLoGoLoading(),);
                 }),

           ),
         ),
    );
  }
}
