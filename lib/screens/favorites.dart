import 'package:flutter/material.dart';
import 'package:stepbit/models/poi.dart';
import 'package:stepbit/utils/overpass_api.dart';
import 'package:stepbit/utils/position.dart';
import 'package:stepbit/widgets/loading.dart';
import 'package:stepbit/widgets/poi_card.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  Future<List<POI>> buildQuery() async {
    final currentPosition = await getCurrentPosition();
    if (currentPosition != null) {
      return OverpassApi.query(
          Map.from({
            'tourism': 'museum',
          }),
          currentPosition,
          1000);
    }
    return Future.error('Unable to fetch location');
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        "TEST",
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
      FutureBuilder(
          future: buildQuery(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<POI> poi = snapshot.data!;
              //poi?.forEach((element) => print(element));
              return Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: poi.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return PoiCard(
                      poi: poi[index],
                    );
                  },
                ),
              );
            } else {
              return const Loading();
            }
          }),
    ]);
  }
}
