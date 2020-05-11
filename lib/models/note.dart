import 'package:uuid/uuid.dart';

class Note {
  String id;
  final String title;
  final String date;
  final int point;
  final bool isBookmarked;

  Note({
    this.id,
    this.title,
    this.date,
    this.point,
    this.isBookmarked,
  });

  assignUUID() {
    id = Uuid().v4();
  }

  factory Note.fromJson(Map<String, dynamic> json) => new Note(
    id: json["id"],
    title: json["title"],
    date: json["date"],
    point: json["point"],
    isBookmarked: json["isBookmarked"] == 1 ? true : false,
  );

  Map<String, dynamic> toJson() => {
    "id" : id,
    "title" : title,
    "date": date,
    "point": point,
    "isBookmarked" : isBookmarked ? 1 : 0,
  };
}