import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stepbit/models/poi.dart';
import 'package:stepbit/utils/position.dart';
import 'package:stepbit/widgets/loading.dart';
import 'package:uuid/uuid.dart';

import '../utils/overpass_api.dart';

class MapWidget extends StatefulWidget {
  late final double data;

  MapWidget({Key? key, required data}) : super(key: key) {
    this.data = data * 500;
  }

  @override
  State<MapWidget> createState() => _MapState();
}

class _MapState extends State<MapWidget> {
  late GoogleMapController _controller;
  final _markers = <MarkerId, Marker>{};

  void _addMarker(POI poi) {
    final markerId = MarkerId(const Uuid().v4());
    final marker = Marker(
      markerId: markerId,
      position: poi.position,
      infoWindow: InfoWindow(
        title: poi.getName(),
        snippet: 'Distance: ${poi.getDistanceKmOrMeters()}',
        //https://www.google.com/maps/search/?api=1&query=<lat>,<lng>
        onTap: () => print("Tap"),
      ),
    );
    setState(() {
      _markers[markerId] = marker;
    });
  }

  Future<List<POI>> _fetchPOI(LatLng currentPosition, double distance) {
    return OverpassApi().query([
      ('tourism', 'attraction'),
      ('tourism', 'viewpoint'),
      ('tourism', 'museum'),
      ('tourism', 'gallery'),
      ('building', 'church'),
      ('building', 'chapel'),
      ('historic', 'building'),
      ('amenity', 'restaurant'),
      ('amenity', 'bar'),
      ('amenity', 'ice_cream'),
    ], currentPosition, distance);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng?>(
      future: getCurrentPosition(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // while data is loading:
          return const Loading();
        }
        // data loaded:
        final position = snapshot.data;
        if (position == null) {
          return const Text("Error retrieving please retry!");
        }

        return GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapType: MapType.terrain,
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer())
          },
          initialCameraPosition: CameraPosition(target: position, zoom: 15),
          onMapCreated: (controller) async {
            _controller = controller;
            final poi = await _fetchPOI(position, widget.data);
            for (var element in poi) {
              _addMarker(element);
            }
          },
          markers: _markers.values.toSet(),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
