import 'dart:async';

import 'package:memo/models/note.dart';
import 'package:memo/service/DBProvider.dart';
import 'package:rxdart/subjects.dart';

class NoteBloc {

  final _noteController = StreamController<List<Note>>.broadcast();
  Stream<List<Note>> get noteStream => _noteController.stream;

  getNotes() async {
    _noteController.sink.add(await DBProvider.db.getNotes());

  }

  NoteBloc() {
    getNotes();
  }

  dispose() {
    _noteController.close();
  }

  Note create(Note note) {
    note.assignUUID();
    DBProvider.db.newNote(note);
    getNotes();
    return note;
  }

  update(Note note) {
    DBProvider.db.updateNote(note);
    getNotes();
  }

  delete(String id) {
    DBProvider.db.deleteNote(id);
    getNotes();
  }

}