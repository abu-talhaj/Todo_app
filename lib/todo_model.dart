class TodoModel {
  int? id;
  String title;
  String content;
  String date;

  TodoModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "title": title,
      "content": content,
      "date": date,
    };
    if (id != null) map["id"] = id;

    return map;
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map["id"],
      title: map["title"],
      content: map["content"],
      date: map['date'],
    );
  }
}
