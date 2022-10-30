class CustomQueue<E> {
  final List<E> _executablesList = [];

  void add(E value) => _executablesList.add(value);

  void addAll(List<E> value) => _executablesList.addAll(value);

  E pop() => _executablesList.removeAt(0);

  List<E> read() => _executablesList.toList();

  bool get isNotEmpty => _executablesList.isNotEmpty;
}
