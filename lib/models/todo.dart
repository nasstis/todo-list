class Todo {
  final String title;
  final String description;
  final String tag;
  Todo({required this.title, required this.description, required this.tag});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'tag': tag,
    };
  }
}
