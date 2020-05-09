import 'dart:async';

import 'package:memo/models/memo.dart';
import 'package:memo/service/DBProvider.dart';

class MemoBloc {
  final String memoId;
  final _memoController = StreamController<List<Memo>>.broadcast();
  Stream<List<Memo>> get memoStream => _memoController.stream;


  getMemos({String type, String noteId}) async {
    _memoController.sink.add(await DBProvider.db.getMemos(type, noteId));
  }

  MemoBloc({this.memoId}) {
    getMemos();
  }

  dispose() {
    _memoController.close();
  }

  create(Memo memo, String type) {
    memo.assignUUID();
    DBProvider.db.newMemo(memo);
    getMemos(type: type, noteId: memo.noteId);
  }

  update(Memo memo, String type) {
    DBProvider.db.updateMemo(memo);
    getMemos(type: type, noteId: memo.noteId);
  }

  delete(String id) {
    DBProvider.db.deleteMemo(id);
  }

}