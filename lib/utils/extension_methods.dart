extension SumIterable on Iterable<int> {
  int sum() {
    if (isEmpty) {
      return 0;
    }
    return reduce((a, b) => a + b);
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
