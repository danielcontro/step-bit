extension SumIterable on Iterable<int> {
  int sum() {
    return reduce((a, b) => a + b);
  }
}
