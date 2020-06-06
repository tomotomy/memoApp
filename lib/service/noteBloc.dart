import 'dart:async';

import 'package:memo/functions/DateToString.dart';
import 'package:memo/models/note.dart';
import 'package:memo/service/DBProvider.dart';

class NoteBloc {
  final String date;
  final _noteController = StreamController<List<Note>>.broadcast();
  final _noteBookmarkedController = StreamController<List<Note>>.broadcast();
  final _calendarNotePointController = StreamController<Map<String, int>>.broadcast();
  Stream<List<Note>> get noteStream => _noteController.stream;
  Stream<List<Note>> get bookmarkedNoteStream => _noteBookmarkedController.stream;
  Stream<Map<String, int>> get calendarNotePointStream => _calendarNotePointController.stream;

  // return last day of month
  DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? new DateTime(month.year, month.month + 1, 1)
        : new DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }

  getNotes(String date) async {
    _noteController.sink.add(await DBProvider.db.getNotes(date));
  }

  getMonthNotes(DateTime month) async {
    final lastDate = lastDayOfMonth(month).day.toInt();
    Map<String, int> monthPoint = Map();
    for (int i = 0; i < lastDate; i++) {
      final date = DateTime(month.year, month.month, i);
      final stringDate = dateToString(date);
      List<Note> notes = await DBProvider.db.getNotes(stringDate);
      if (notes.isNotEmpty) {
        num sum = 0;
        notes.forEach((note) {
          sum += note.totalPoint;
        });
        monthPoint[stringDate] = sum;
      } 
    }
    _calendarNotePointController.sink.add(monthPoint);
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