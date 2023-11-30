import 'dart:collection';

extension FlatMap<T> on Iterable<T> {
  Iterable<U> flatMap<U>(Iterable<U> Function(T element) mapper) {
    return _FlatMapIterable<T, U>(this, mapper);
  }
}

extension PickByDotNotation on Map<String, dynamic> {
  Map<String, dynamic> pick(Iterable<String> dotNotationFields) {
    final result = <String, dynamic>{};
    for (String field in dotNotationFields) {
      final parts = field.split('.');
      Map<String, dynamic> object = this;
      for (int i = 0; i < parts.length - 1; i++) {
        final part = parts[i];
        if (!object.containsKey(part)) {
          break;
        }
        object = object[part];
      }
      final lastPart = parts.last;
      if (object.containsKey(lastPart)) {
        result[lastPart] = object[lastPart];
      }
    }
    return result;
  }
}

class _FlatMapIterable<T, U> with IterableBase<U> {
  final Iterable<T> source;
  final Iterable<U> Function(T element) mapper;

  const _FlatMapIterable(this.source, this.mapper);

  @override
  Iterator<U> get iterator => _FlatMapIterator(source, mapper);
}

class _FlatMapIterator<T, U> implements Iterator<U> {
  final Iterable<T> source;
  final Iterable<U> Function(T element) mapper;

  late Iterator<T> sourceIterator;
  Iterator<U>? currentIterator;

  _FlatMapIterator(this.source, this.mapper) {
    sourceIterator = this.source.iterator;
  }

  @override
  U get current => currentIterator!.current;

  @override
  bool moveNext() {
    if (currentIterator == null) {
      if (!sourceIterator.moveNext()) {
        return false;
      }
      currentIterator = mapper(sourceIterator.current).iterator;
    }
    while (!currentIterator!.moveNext()) {
      if (!sourceIterator.moveNext()) {
        return false;
      }
      currentIterator = mapper(sourceIterator.current).iterator;
    }
    return true;
  }
}
