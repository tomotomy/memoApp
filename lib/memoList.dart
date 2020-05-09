import 'package:flutter/material.dart';
import 'package:memo/functions/StringToColor.dart';
import 'package:memo/memoForm.dart';
import 'package:memo/models/memo.dart';
import 'package:memo/service/memoBloc.dart';
import 'package:provider/provider.dart';

enum LoadingStatus {
  LOADING,
  COMPLETE
}

class MemoList extends StatefulWidget {
  final type;
  final String noteId;
  final note;
  final MemoBloc bloc;
  MemoList({
    this.type,
    @required this.noteId,
    @required this.note,
    @required this.bloc,
  });

  @override
  _MemoListState createState() => _MemoListState();
}

class _MemoListState extends State<MemoList> {
  MemoBloc bloc;
  LoadingStatus _loadingStatus;

  @override
  void initState() {
    bloc = widget.bloc;
    // TODO: implement initState
    super.initState();
  }


  Widget memoCard(Memo data) {
    final color = stringToColor(data.labelColor);
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        ),
        color: Colors.redAccent,
      ),
      onDismissed: (direction) {
        bloc.delete(data.id);
        Scaffold.of(context).showSnackBar(
          new SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "メモを削除しました",
              style: TextStyle(
                fontSize: 16
              ),
            )
          ),
        );
      },
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MemoForm(
                type: widget.type,
                noteId: widget.noteId,
                memo: data,
                note: widget.note,
                bloc: bloc,
              ),
            )
          );
        },
        child: Card(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 20,
                height: 100,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10,10,10,10),
                height: 100,
                child: Text(
                  data.contents,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  )
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Scaffold(
      body: StreamBuilder<List<Memo>>(
        stream: bloc.memoStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.data.length == 0) {
              return Container(
                child: Center(
                  child: Text("日々の気づきをメモに残しましょう"),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = snapshot.data[index];
                  return memoCard(data);
                },
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }
}