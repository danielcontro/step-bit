import 'package:easy_settings/easy_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:geocoding/geocoding.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stepbit/database/entities/favorite.dart';
import 'package:stepbit/database/entities/person_favorite.dart';
import 'package:stepbit/models/poi.dart';
import 'package:stepbit/screens/settings.dart';
import 'package:stepbit/utils/api_client.dart';
import 'package:stepbit/utils/discount_api.dart';
import 'package:stepbit/utils/extension_methods.dart';
import 'package:stepbit/utils/token_manager.dart';
import 'package:uuid/uuid.dart';

import '../database/entities/discount.dart';
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

  Future<Discount?> _getDiscount(DatabaseRepository dbr) async {
    final username = await TokenManager.getUsername();
    return await dbr.getDiscount(username!, poi.getName());
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
            child: DiscountAPI.canHaveDiscount(poi)
                ? PropertyChangeProvider<SettingsPropertyChangedNotifier,
                        String>(
                    value: settingsPropertyChangedNotifier,
                    child: PropertyChangeConsumer<
                            SettingsPropertyChangedNotifier, String>(
                        properties: const [dailyStepsGoalKey],
                        builder: (p0, p1, p2) {
                          return FutureBuilder<Discount?>(
                              future: _getDiscount(
                                  Provider.of<DatabaseRepository>(context,
                                      listen: true)),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return const CircularProgressIndicator();
                                }
                                var discount = snapshot.data;
                                if (discount == null) {
                                  return TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 20),
                                      backgroundColor: const Color.fromRGBO(
                                          116, 138, 77, 0.89),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("Request Discount"),
                                    onPressed: () => (_requestDiscount(
                                        context,
                                        Provider.of<DatabaseRepository>(context,
                                            listen: false))),
                                  );
                                }
                                return Container(
                                    color: Colors.white,
                                    child: QrImageView(
                                      data: discount.description,
                                      version: QrVersions.auto,
                                      size: 200.0,
                                    ));
                              });
                        }))
                : null));

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
                final favorite = snapshot.data;
                final isFavorite = (favorite == null) ? false : true;
                return FloatingActionButton.small(
                  heroTag: null,
                  backgroundColor: Colors.lime,
                  child: isFavorite
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                  onPressed: () => isFavorite
                      ? _removeFavorite(context, favorite)
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

  void _requestDiscount(BuildContext context, DatabaseRepository dbr) async {
    final discountResponse = await DiscountAPI.isEligibleForDiscount(
        dbr,
        (await ApiClient.getSteps(
                DateTime.now().subtract(const Duration(days: 1)))) ??
            0,
        getSettingsPropertyValue<int>(dailyStepsGoalKey));

    if (discountResponse == DiscountResponse.incompleteGoal &&
        context.mounted) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
              content:
                  Text('Complete the daily goal for requesting discounts')),
        );
      return null;
    }

    if (discountResponse == DiscountResponse.dailyDiscountsLimit &&
        context.mounted) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Daily limit reached')),
        );
      return null;
    }

    final id = const Uuid().v4();
    if (context.mounted) {
      final database = Provider.of<DatabaseRepository>(context, listen: false);

      var favorite = await database.findFavoriteByName(poi.getName());
      if (favorite == null) {
        favorite = Favorite(
            const Uuid().v4(),
            poi.getName(),
            await getCity() ?? "",
            poi.position.latitude,
            poi.position.longitude,
            poi.getStreet() ?? "",
            poi.getType());
        await database.addNewFavorite(favorite);
      }
      database.addNewDiscount(Discount(
          id,
          favorite.id,
          (await TokenManager.getUsername())!,
          const Uuid().v4(),
          DateTime.now(),
          DateTime.now().add(const Duration(days: 7))));
      return;
    }
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
              .addNewPersonFavorite(
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
