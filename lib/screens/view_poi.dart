import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:stepbit/database/entities/favorite.dart';
import 'package:stepbit/database/entities/person_favorite.dart';
import 'package:stepbit/models/poi.dart';
import 'package:stepbit/utils/extension_methods.dart';
import 'package:uuid/uuid.dart';

import '../repositories/database_repository.dart';

class ViewPOI extends StatelessWidget {
  final POI poi;

  const ViewPOI({super.key, required this.poi});

  Future<String?> getCity() async {
    if (poi.getCity() != null) {
      return poi.getCity()!;
    }
    try {
      final placemarks = await placemarkFromCoordinates(
          poi.position.latitude, poi.position.longitude);
      return placemarks.firstOrNull?.locality;
    } catch (err) {
      return null;
    }
  }

  Widget getCityWidget() {
    return FutureBuilder(
      future: getCity(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final locality = snapshot.data as String;
          return Text(
            'City: $locality',
            style: const TextStyle(fontSize: 20),
          );
        } else {
          return const Text('');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 20,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            poi.getName(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
          Row(children: [
            const Text('Type: ', style: textStyle),
            poi.getIcon(),
            Text(' ${poi.getType().capitalize()}', style: textStyle),
          ]),
          Row(children: [
            const Text('Distance: ', style: textStyle),
            const Icon(Icons.timeline, size: 20),
            Text(' ${poi.getDistanceKmOrMeters()}', style: textStyle),
          ]),
          getCityWidget(),
          if (poi.getStreet() != null)
            Text(
              'Street: ${poi.getStreet()}',
              style: textStyle,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final availableMaps = await MapLauncher.installedMaps;
                  if (availableMaps.isNotEmpty) {
                    await availableMaps.first.showMarker(
                      coords: Coords(
                        poi.position.latitude,
                        poi.position.longitude,
                      ),
                      title: poi.getName(),
                    );
                  }
                },
                child: const Text("View on the map"),
              ),
              ElevatedButton(
                onPressed: () => _addFavorite(context),
                child: const Text("Add to favorites"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addFavorite(BuildContext context) async {
    final city = await getCity();
    final id = const Uuid().v4();
    if (context.mounted) {
      await Provider.of<DatabaseRepository>(context, listen: false)
          .database
          .favoriteDao
          .insertFavorite(Favorite(
            id,
            poi.getName(),
            city ?? "",
            poi.position.latitude,
            poi.position.longitude,
            poi.getStreet() ?? "",
            poi.getType(),
          ));
    }
    if (context.mounted) {
      await Provider.of<DatabaseRepository>(context, listen: false)
          .database
          .personFavoriteDao
          .insertPersonFavorite(PersonFavorite(1, id));
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Added to favorites')),
        );
    }
  }
}
