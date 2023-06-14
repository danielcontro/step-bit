extension SumIterable on Iterable<int> {
  int sum() {
    if (isEmpty) {
      return 0;
    }
    return reduce((a, b) => a + b);
  }
}
