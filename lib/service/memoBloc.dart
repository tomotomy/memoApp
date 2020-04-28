import 'dart:async';

import 'package:memo/models/memo.dart';
import 'package:memo/service/DBProvider.dart';

class MemoBloc {

  final _memoController = StreamController<List<Memo>>();
  Stream<List<Memo>> get memoStream => _memoController.stream;

  getMemos({String type}) async {
    _memoController.sink.add(await DBProvider.db.getMemos());
  }

  MemoBloc() {
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