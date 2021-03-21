import 'dart:async';

import 'package:flutter/material.dart';

import 'package:qr2/models/scan_model.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  MapType mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    final CameraPosition positionInitial = CameraPosition(
      target: scan.getLatLng(),
      zoom: 17,
    );

    Set<Marker> markers = new Set<Marker>();
    markers.add(new Marker(
      markerId: MarkerId('geo-location'),
      position: scan.getLatLng(),
    ));

    return Scaffold(
        appBar: AppBar(
          title: Text('Map'),
          actions: [
            IconButton(
                icon: Icon(Icons.location_on),
                onPressed: () async {
                  final GoogleMapController controller =
                      await _controller.future;
                  controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: scan.getLatLng(), zoom: 17)));
                })
          ],
        ),
        body: GoogleMap(
          mapType: mapType,
          markers: markers,
          initialCameraPosition: positionInitial,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.layers),
          onPressed: () {
            if (mapType == MapType.normal) {
              mapType = MapType.satellite;
            } else {
              mapType = MapType.normal;
            }

            setState(() {});
          },
        ));
  }
}
