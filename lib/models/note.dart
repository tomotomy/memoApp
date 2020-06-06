import 'package:uuid/uuid.dart';

class Note {
  String id;
  final String title;
  final String date;
  final bool isBookmarked;
  final int matter;
  final int abstraction;
  final int diversion;
  final int totalPoint;

  Note({
    this.id,
    this.title,
    this.date,
    this.isBookmarked,
    this.matter = 0,
    this.abstraction = 0,
    this.diversion = 0,
    this.totalPoint = 0,
  });

  assignUUID() {
    id = Uuid().v4();
  }

  factory Note.fromJson(Map<String, dynamic> json) => new Note(
    id: json["id"],
    title: json["title"],
    date: json["date"],
    isBookmarked: json["isBookmarked"] == 1 ? true : false,
    matter: json['matter'],
    abstraction: json['abstraction'],
    diversion: json['diversion'],
    totalPoint: json['totalPoint'],
  );

  Map<String, dynamic> toJson() => {
    "id" : id,
    "title" : title,
    "date": date,
    "isBookmarked" : isBookmarked ? 1 : 0,
    "matter" : matter,
    "abstraction" : abstraction,
    "diversion" : diversion,
    "totalPoint" : totalPoint,
  };
}