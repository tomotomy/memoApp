import 'package:flutter/material.dart';
import 'package:memo/functions/StringToColor.dart';
import 'package:memo/memoForm.dart';
import 'package:memo/models/memo.dart';
import 'package:memo/models/note.dart';
import 'package:memo/service/memoBloc.dart';
import 'package:memo/service/noteBloc.dart';

enum LoadingStatus {
  LOADING,
  COMPLETE
}

class MemoList extends StatefulWidget {
  final type;
  final String noteId;
  final note;
  final MemoBloc memoBloc;
  final NoteBloc noteBloc;
  MemoList({
    this.type,
    @required this.noteId,
    @required this.note,
    @required this.memoBloc,
    @required this.noteBloc
  });

  @override
  _MemoListState createState() => _MemoListState();
}

class _MemoListState extends State<MemoList> {
  MemoBloc memoBloc;
  NoteBloc noteBloc;
  LoadingStatus _loadingStatus;

  @override
  void initState() {
    memoBloc = widget.memoBloc;
    noteBloc = widget.noteBloc;
    // TODO: implement initState
    super.initState();
  }

  void updateNoteNumber() {
    int point;
    if (widget.type == '事象') {
      point = 1;
    } else if (widget.type == '抽象') {
      point = 3;
    } else {
      point = 5;
    }
    widget.noteBloc.update(
      Note(
        id: widget.note.id,
        title: widget.note.title,
        isBookmarked: widget.note.isBookmarked,
        date: widget.note.date,
        matter: widget.type == '事象' ? (widget.note.matter - 1) : widget.note.matter,
        abstraction: widget.type == '抽象' ? (widget.note.abstraction - 1) : widget.note.abstraction,
        diversion: widget.type == '転用' ? (widget.note.diversion - 1) : widget.note.diversion, 
        totalPoint: widget.note.totalPoint - point,
      )
    );
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
        memoBloc.delete(data.id);
        updateNoteNumber();
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
                memoBloc: memoBloc,
                noteBloc: widget.noteBloc,
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
        stream: memoBloc.memoStream,
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
              return ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  print(oldIndex);
                  print(newIndex);
                },
                children: snapshot.data.map((data) {
                  return memoCard(data);
                }).toList(),
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