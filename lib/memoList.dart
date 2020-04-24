import 'package:flutter/material.dart';
import 'package:memo/models/memo.dart';
import 'package:memo/service/memoBloc.dart';
import 'package:provider/provider.dart';

class MemoList extends StatefulWidget {
  final type;
  MemoList({this.type});

  @override
  _MemoListState createState() => _MemoListState();
}

class _MemoListState extends State<MemoList> {
  final bloc = MemoBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Memo>>(
      stream: bloc.memoStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          return ListView(
            children: snapshot.data.map((data) {
              return Card(
                child: Text(data.contents),
              );
            }).toList(),
          );
        }
      },
    );
  }
}