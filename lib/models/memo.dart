import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class Memo {
  String id;
  final String title;
  final String contents;
  final String labelColor;
  final String type;

  Memo({
    this.id,
    this.title,
    this.contents,
    this.labelColor,
    this.type,
  });

  assignUUID() {
    id = Uuid().v4();
  }

  factory Memo.fromJson(Map<String, dynamic> json) => new Memo(
    id: json["id"],
    title: json["title"],
    contents: json["contents"],
    labelColor: json["labelColor"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id" : id,
    "title" : title,
    "contents" : contents,
    "labelColor" : labelColor,
    "type" : type
  };
}
