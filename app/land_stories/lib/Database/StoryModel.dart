import 'dart:convert';

Story storyFromJson(String str) {
  final jsonData = json.decode(str);
  return Story.fromMap(jsonData);
}

String storyToJson(Story data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Story {
  int id;
  String heading;
  String context;
  bool status;

  Story({
    this.id,
    this.heading,
    this.context,
    this.status,
  });

  factory Story.fromMap(Map<String, dynamic> json) => new Story(
        id: json["id"],
        heading: json["heading"],
        context: json["context"],
        status: json["status"] == 1,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "heading": heading,
        "context": context,
        "status": status,
      };
}
