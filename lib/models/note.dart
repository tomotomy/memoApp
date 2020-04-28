import 'package:uuid/uuid.dart';

class Note {
  String id;
  final String title;
  final String date;

  Note({
    this.id,
    this.title,
    this.date
  });

  assignUUID() {
    id = Uuid().v4();
  }

  factory Note.fromJson(Map<String, dynamic> json) => new Note(
    id: json["id"],
    title: json["title"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id" : id,
    "title" : title,
    "date": date,
  };
}