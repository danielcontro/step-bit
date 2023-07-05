import 'package:stepbit/models/exercise.dart';

class DiscountAPI {
  static Future<bool> eligibleForDiscount(
      int dailySteps, int threshold, int numberOfDailyDiscounts) {
    return Future(() => dailySteps >= threshold);
  }

  Future<String> requestDiscount(List<Exercise> lastWeekExercises) {
    return Future(() => "");
  }
}
