import 'package:stepbit/models/exercise.dart';
import 'package:stepbit/repositories/database_repository.dart';
import 'package:stepbit/utils/token_manager.dart';

import '../models/poi.dart';

class DiscountAPI {
  static const int _dailyDiscounts = 2;
  static const List<String> _canHaveDiscount = [
    'restaurant',
    'bar',
    'ice_cream'
  ];

  static Future<bool> isEligibleForDiscount(
      DatabaseRepository dbr, int dailySteps, int threshold) async {
    var discounts =
        await dbr.findDiscountsByUsername((await TokenManager.getUsername())!);

    if (discounts.isEmpty) return dailySteps >= threshold;

    for (var discount in discounts) {
      if (discount.isExpired()) {
        discounts.remove(discount);
        await dbr.deleteDiscount(discount);
      }
    }
    discounts.removeWhere(
        (element) => DateTime.now().difference(element.issued).inDays >= 1);
    return discounts.length < _dailyDiscounts && dailySteps >= threshold;
  }

  static bool canHaveDiscount(POI poi) {
    return _canHaveDiscount.contains(poi.getType());
  }

  Future<String> requestDiscount(List<Exercise> lastWeekExercises) {
    return Future(() => "");
  }
}
