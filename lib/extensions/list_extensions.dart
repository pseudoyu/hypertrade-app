extension ListExtensions<T> on List<T> {
  List<T> takeLast(int count) {
    if (count >= length) {
      return List<T>.from(this);
    }
    return sublist(length - count);
  }
}
