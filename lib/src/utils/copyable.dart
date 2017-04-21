part of ose_utils;

/// Interface provides method to copy data from specific objects.
abstract class Copyable<T> {
  /// Clone from [obj].
  void copyFrom(T obj);
}
