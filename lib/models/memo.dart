import 'package:uuid/uuid.dart';

class Memo {
  String id;
  String noteId;
  final String title;
  final String contents;
  final String labelColor;
  final String type;
  final int order;

  Memo({
    this.id,
    this.noteId,
    this.title,
    this.contents,
    this.labelColor,
    this.type,
    this.order,
  });

  assignUUID() {
    id = Uuid().v4();
  }

  factory Memo.fromJson(Map<String, dynamic> json) => new Memo(
    id: json["id"],
    noteId: json["noteId"],
    title: json["title"],
    contents: json["contents"],
    labelColor: json["labelColor"],
    type: json["type"],
    order: json["order"],
  );

  Map<String, dynamic> toJson() => {
    "id" : id,
    "noteId": noteId,
    "title" : title,
    "contents" : contents,
    "labelColor" : labelColor,
    "type" : type,
    "order" : order
  };
}
