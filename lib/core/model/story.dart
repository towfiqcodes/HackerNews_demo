import 'dart:convert';

Story storyFromJson(String str) => Story.fromJson(json.decode(str));

String storyToJson(Story data) => json.encode(data.toJson());

class Story {
  Story({
    this.by = '',
    this.descendants = 0,
    this.id = 0,
    this.kids = const [],
    this.score = 0,
    this.time = 0,
    this.title = '',
    this.type = '',
    this.url = '',
    this.text = ''
  });

  String by;
  int descendants;
  int id;
  List<int> kids;
  int score;
  int time;
  String title;
  String type;
  String url;
  String text;

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    by: json["by"] ?? '',
    descendants: json["descendants"] ?? 0,
    id: json["id"] ?? 0,
    kids: json["kids"] != null ? List<int>.from(json["kids"].map((x) => x)) : const [],
    score: json["score"] ?? 0,
    time: json["time"] ?? 0,
    title: json["title"] ?? "",
    type: json["type"] ?? "",
    url: json["url"] ?? "",
    text: json["text"] ?? ""
  );

  Map<String, dynamic> toJson() => {
    "by": by,
    "descendants": descendants,
    "id": id,
    "kids": List<dynamic>.from(kids.map((x) => x)),
    "score": score,
    "time": time,
    "title": title,
    "type": type,
    "url": url,
    "text": text
  };
}
