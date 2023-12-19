class Todo{
  // late - variable will be initialized later
  // Useful for not-nullable variable since you can't provide value immediately

  late String id;
  late String title;
  late String description;
  late bool isCompleted;
  late bool isDateDisplayed;
  late String timestamp;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.isDateDisplayed,
    required this.timestamp,
  });
}