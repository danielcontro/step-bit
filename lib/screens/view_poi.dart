import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:geocoding/geocoding.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stepbit/database/entities/favorite.dart';
import 'package:stepbit/database/entities/person_favorite.dart';
import 'package:stepbit/models/poi.dart';
import 'package:stepbit/utils/extension_methods.dart';
import 'package:stepbit/utils/token_manager.dart';
import 'package:uuid/uuid.dart';

import '../repositories/database_repository.dart';

class ViewPOI extends StatelessWidget {
  final POI poi;

  const ViewPOI({
    super.key,
    required this.poi,
  });

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
          return Text('City: $locality');
        } else {
          return const Text('');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            POI.getIcon(poi.getType()),
            const SizedBox(width: 10.0),
            Text(poi.getType().capitalize()),
          ],
        ),
        const SizedBox(
          width: 90.0,
          child: Divider(color: Colors.lime),
        ),
        const SizedBox(height: 10.0),
        Text(
          poi.getName(),
          style: const TextStyle(fontSize: 45.0),
        ),
        const SizedBox(height: 30.0),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Distance: ${poi.getDistanceKmOrMeters()}'),
              getCityWidget(),
              if (poi.getStreet() != null) Text('Street: ${poi.getStreet()}'),
            ],
          ),
        ),
      ],
    );

    final topContent = Container(
      height: MediaQuery.of(context).size.height * 0.40,
      padding: const EdgeInsets.all(40.0),
      width: MediaQuery.of(context).size.width,
      decoration:
          const BoxDecoration(color: Color.fromRGBO(116, 138, 77, 0.89)),
      child: Center(
        child: topContentText,
      ),
    );

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(40.0),
      child: Center(
          child: Container(
        color: Colors.white,
        child: QrImageView(
          data: "test",
          version: QrVersions.auto,
          size: 200.0,
        ),
      )
          //       FutureBuilder<Widget>(
          //       future: ,
          //         builder: (context, snapshot) {
          //           FloatingActionButton(
          //               child: const Text("Request Discount"),
          //               onPressed: () => (eligibleForDiscount ? () : null));

          //         }
          ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: key,
        type: ExpandableFabType.fan,
        fanAngle: 90,
        backgroundColor: Colors.lime,
        closeButtonStyle: const ExpandableFabCloseButtonStyle(
          backgroundColor: Colors.lime,
        ),
        child: const Icon(Icons.question_mark),
        children: [
          FutureBuilder<Favorite?>(
              future: Provider.of<DatabaseRepository>(context, listen: true)
                  .findFavoriteByName(poi.getName()),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  // while data is loading:
                  return const CircularProgressIndicator();
                }
                // data loaded:
                var isFavorite = true;
                final favorite = snapshot.data;
                if (favorite == null) {
                  isFavorite = false;
                }
                return FloatingActionButton.small(
                  heroTag: null,
                  backgroundColor: Colors.lime,
                  child: isFavorite
                      ? const Icon(Icons.favorite_border)
                      : const Icon(Icons.favorite),
                  onPressed: () => isFavorite
                      ? _removeFavorite(context, favorite!)
                      : _addFavorite(context),
                );
              }),
          FloatingActionButton.small(
            heroTag: null,
            backgroundColor: Colors.lime,
            child: const Icon(Icons.map),
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
          )
        ],
      ),
    );
  }

  void _addFavorite(BuildContext context) async {
    final city = await getCity();
    final id = const Uuid().v4();
    if (context.mounted) {
      final poiDB =
          await Provider.of<DatabaseRepository>(context, listen: false)
              .findFavoriteByName(poi.getName());
      if (poiDB == null) {
        if (context.mounted) {
          await Provider.of<DatabaseRepository>(context, listen: false)
              .addNewFavorite(
                  Favorite(
                    id,
                    poi.getName(),
                    city ?? "",
                    poi.position.latitude,
                    poi.position.longitude,
                    poi.getStreet() ?? "",
                    poi.getType(),
                  ),
                  PersonFavorite((await TokenManager.getUsername())!, id));
          if (context.mounted) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Added to favorites')),
              );
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Already added')),
            );
        }
      }
    }
  }

  void _removeFavorite(BuildContext context, Favorite favorite) async {
    if (context.mounted) {
      await Provider.of<DatabaseRepository>(context, listen: false)
          .deleteFavorite((await TokenManager.getUsername())!, favorite);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Removed from favorites')),
          );
      }
    }
  }
}
