import 'package:uuid/uuid.dart';

class Note {
  String id;
  final String title;
  final String date;
  final int point;

  Note({
    this.id,
    this.title,
    this.date,
    this.point
  });

  assignUUID() {
    id = Uuid().v4();
  }

  factory Note.fromJson(Map<String, dynamic> json) => new Note(
    id: json["id"],
    title: json["title"],
    date: json["date"],
    point: json["point"]
  );

  Map<String, dynamic> toJson() => {
    "id" : id,
    "title" : title,
    "date": date,
    "point": point
  };
}