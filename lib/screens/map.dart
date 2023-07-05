import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stepbit/models/poi.dart';
import 'package:stepbit/repositories/database_repository.dart';
import 'package:stepbit/screens/view_poi.dart';
import 'package:stepbit/utils/position.dart';
import 'package:stepbit/widgets/loading.dart';
import 'package:uuid/uuid.dart';

import '../utils/overpass_api.dart';

class MapWidget extends StatefulWidget {
  late final double data;

  MapWidget({Key? key, required double data}) : super(key: key) {
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
        snippet: 'Tap to view details',
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewPOI(
                        poi: poi,
                      )));
        },
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
      future: Position.getCurrentPosition(),
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
          buildingsEnabled: false,
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer())
          },
          initialCameraPosition: CameraPosition(target: position, zoom: 15),
          onMapCreated: (controller) async {
            _controller = controller;
            _controller.setMapStyle("""
            [
              {
                "elementType": "labels",
                "stylers": [
                  {
                    "visibility": "off"
                  }
                ]
              },
              {
                "featureType": "administrative.locality",
                "stylers": [
                  {
                    "visibility": "on"
                  }
                ]
              }
            ]""");

            final poi = await _fetchPOI(position, widget.data);
            _markers.clear();
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
