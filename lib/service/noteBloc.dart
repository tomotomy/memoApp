import 'dart:async';

import 'package:memo/models/note.dart';
import 'package:memo/service/DBProvider.dart';

class NoteBloc {
  final String date;
  final _noteController = StreamController<List<Note>>.broadcast();
  final _noteBookmarkedController = StreamController<List<Note>>.broadcast();
  final _calendarNoteController = StreamController<Map<String, int>>.broadcast();
  Stream<List<Note>> get noteStream => _noteController.stream;
  Stream<List<Note>> get bookmarkedNoteStream => _noteBookmarkedController.stream;
  Stream<Map<String, int>> get calendarNoteStream => _calendarNoteController.stream;


  getNotes(String date) async {
    _noteController.sink.add(await DBProvider.db.getNotes(date));
    _calendarNoteController.add(await DBProvider.db.getAllNotes());
  }

  getBookmarkedNotes() async {
    _noteBookmarkedController.sink.add(await DBProvider.db.getBookmarkedNotes());
  }

  NoteBloc({this.date}) {
    getNotes(date);
  }

  dispose() {
    _noteController.close();
  }

  Note create(Note note) {
    note.assignUUID();
    DBProvider.db.newNote(note);
    getNotes(note.date);
    return note;
  }

  update(Note note) {
    DBProvider.db.updateNote(note);
    getNotes(note.date);
  }

  delete(String id, String date) {
    DBProvider.db.deleteNote(id);
    getNotes(date);
  }

}