import 'dart:convert';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  Comment({
    this.by = '',
    this.id = 0,
    this.kids = const [],
    this.parent = 0,
    this.text = '',
    this.time = 0,
    this.type = '',
  });

  String by;
  int id;
  List<int> kids;
  int parent;
  String text;
  int time;
  String type;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        by: json["by"] ?? '',
        id: json["id"] ?? 0,
        kids: json["kids"] != null? List<int>.from(json["kids"].map((x) => x)) : const [],
        parent: json["parent"] ?? 0,
        text: json["text"] ?? '',
        time: json["time"] ?? 0,
        type: json["type"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "by": by,
        "id": id,
        "kids": List<dynamic>.from(kids.map((x) => x)),
        "parent": parent,
        "text": text,
        "time": time,
        "type": type,
      };
}
