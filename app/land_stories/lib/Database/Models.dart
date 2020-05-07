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

  Story({
    this.id,
    this.heading,
    this.context,
  });

  factory Story.fromMap(Map<String, dynamic> json) => new Story(
        id: json["id"],
        heading: json["heading"],
        context: json["context"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "heading": heading,
        "context": context,
      };
}

Task taskFromJson(String str) {
  final jsonData = json.decode(str);
  return Task.fromMap(jsonData);
}

class Task {
  int id;
  String heading;
  String context;
  int due;
  bool status;

  Task({
    this.id,
    this.heading,
    this.context,
    this.due,
    this.status,
  });

  factory Task.fromMap(Map<String, dynamic> json) => new Task(
        id: json["id"],
        heading: json["heading"],
        context: json["context"],
        due: json["due"],
        status: json["status"] == 1,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "heading": heading,
        "context": context,
        "due": due,
        "status": status,
      };
}

Task changeFromJson(String str) {
  final jsonData = json.decode(str);
  return Task.fromMap(jsonData);
}

class Change {
  int id;
  int storyid;
  String datetime;
  String newValue;
  String oldValue;

  Change({
    this.id,
    this.storyid,
    this.datetime,
    this.newValue,
    this.oldValue,
  });

  factory Change.fromMap(Map<String, dynamic> json) => new Change(
        id: json["id"],
        storyid: json["storyid"],
        datetime: json["datetime"],
        newValue: json["newValue"],
        oldValue: json["oldValue"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "storyid": storyid,
        "datetime": datetime,
        "newValue": newValue,
        "oldValue": oldValue,
      };
}
