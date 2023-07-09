import 'package:stepbit/models/exercise.dart';
import 'package:stepbit/repositories/database_repository.dart';
import 'package:stepbit/utils/token_manager.dart';

import '../database/entities/discount.dart';
import '../models/poi.dart';

enum DiscountResponse {
  eligibleForDiscount,
  incompleteGoal,
  dailyDiscountsLimit
}

class DiscountAPI {
  static const int _dailyDiscounts = 2;
  static const List<String> _canHaveDiscount = [
    'restaurant',
    'bar',
    'ice_cream'
  ];

  static Future<DiscountResponse> isEligibleForDiscount(
      DatabaseRepository dbr, int dailySteps, int threshold) async {
    var discounts =
        await dbr.findDiscountsByUsername((await TokenManager.getUsername())!);

    if (dailySteps < threshold) return DiscountResponse.incompleteGoal;

    final discountsToRemove =
        discounts.fold<List<Discount>>([], (previousValue, element) {
      if (element.isExpired()) previousValue.add(element);
      return previousValue;
    });

    for (var discount in discountsToRemove) {
      if (discount.isExpired()) {
        discounts.remove(discount);
        await dbr.deleteDiscount(discount);
      }
    }
    discounts.removeWhere(
        (element) => DateTime.now().difference(element.issued).inDays >= 1);
    return (discounts.length >= _dailyDiscounts)
        ? DiscountResponse.dailyDiscountsLimit
        : DiscountResponse.eligibleForDiscount;
  }

  static bool canHaveDiscount(POI poi) {
    return _canHaveDiscount.contains(poi.getType());
  }

  Future<String> requestDiscount(List<Exercise> lastWeekExercises) {
    return Future(() => "");
  }
}
