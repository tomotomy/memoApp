import 'dart:async';

import 'package:memo/models/memo.dart';
import 'package:memo/service/DBProvider.dart';

class MemoBloc {
  final String noteId;
  final _memoController = StreamController<List<Memo>>.broadcast();
  Stream<List<Memo>> get memoStream => _memoController.stream;


  getMemos({String type, String noteId}) async {
    _memoController.sink.add(await DBProvider.db.getMemos(type, noteId));
  }

  MemoBloc({this.noteId}) {
    getMemos();
  }

  dispose() {
    _memoController.close();
  }

  create(Memo memo) {
    memo.assignUUID();
    DBProvider.db.newMemo(memo);
    getMemos();
  }

  update(Memo memo) {
    DBProvider.db.updateMemo(memo);
    getMemos();
  }

  delete(String id) {
    DBProvider.db.deleteMemo(id);
    getMemos();
  }

}