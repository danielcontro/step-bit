import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stepbit/utils/position.dart';
import 'package:uuid/uuid.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key, required this.data, required this.callback})
      : super(key: key);

  @override
  State<MapWidget> createState() => _MapState();

  final int data;
  final Function callback;
}

class _MapState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  void _addMarker(LatLng position) {
    final markerId = MarkerId(const Uuid().v4());
    final Marker marker = Marker(markerId: markerId, position: position);
    setState(() {
      _markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    /*return Text('Maps ${widget.data}',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));*/
    /*return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        Text(
          'Maps ${widget.data}',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        FutureBuilder<LatLng>(
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
                  mapType: MapType.normal,
                  initialCameraPosition:
                      CameraPosition(target: position, zoom: 15),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: _markers.values.toSet(),
                );
              }
            }),
      ],
    );*/
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
              mapType: MapType.normal,
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
