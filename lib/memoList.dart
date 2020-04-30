import 'package:flutter/material.dart';
import 'package:memo/functions/StringToColor.dart';
import 'package:memo/memoForm.dart';
import 'package:memo/models/memo.dart';
import 'package:memo/service/memoBloc.dart';
import 'package:provider/provider.dart';

class MemoList extends StatefulWidget {
  final type;
  final String noteId;
  final note;
  MemoList({
    this.type,
    this.noteId,
    this.note,
  });

  @override
  _MemoListState createState() => _MemoListState();
}

class _MemoListState extends State<MemoList> {
  final bloc = MemoBloc();

  @override
  void initState() {
    bloc.getMemos(type: widget.type, noteId: widget.noteId);
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
              final color = stringToColor(data.labelColor);
              return InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MemoForm(
                        type: widget.type,
                        noteId: widget.noteId,
                        memo: data,
                        note: widget.note,
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
                        padding: EdgeInsets.fromLTRB(10,20,10,20),
                        height: 100,
                        child: Text(
                          data.contents,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}