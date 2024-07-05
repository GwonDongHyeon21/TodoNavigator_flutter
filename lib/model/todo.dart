class Todo {
  final String title;
  final DateTime date;
  final String startLocation;
  final String endLocation;
  bool isDone;

  Todo({
    required this.title,
    required this.date,
    required this.startLocation,
    required this.endLocation,
    this.isDone = false,
  });
}
