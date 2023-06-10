import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stepbit/models/poi.dart';
import 'package:stepbit/utils/position.dart';
import 'package:uuid/uuid.dart';

class MapWidget extends StatefulWidget {
  final double data;

  const MapWidget({Key? key, required this.data}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapState();
}

class _MapState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  void _addMarker(POI poi) {
    final markerId = MarkerId(const Uuid().v4());
    final Marker marker = Marker(
        markerId: markerId,
        position: poi.position,
        infoWindow: InfoWindow(
          title: poi.getName(),
          snippet: 'Distance: ${poi.getDistanceKmOrMeters()}',
          //https://www.google.com/maps/search/?api=1&query=<lat>,<lng>
          onTap: () => print("Tap"),
        ));
    setState(() {
      _markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    /*return Text('Maps ${(widget.data * 500).round()}',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));*/
    const test = POI(
      position: LatLng(45.411119, 11.887978),
      tags: {'name': 'Test'},
      distanceInKm: 0.2,
    );
    _addMarker(test);
    return FutureBuilder<LatLng>(
        future: getCurrentPosition(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // while data is loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // data loaded:
            final position = snapshot.data;
            if (position == null) {
              return const Text("Error retrieving please retry!");
            }
            return GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.terrain,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer())
              },
              initialCameraPosition: CameraPosition(target: position, zoom: 15),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers.values.toSet(),
            );
          }
        });
  }
}
