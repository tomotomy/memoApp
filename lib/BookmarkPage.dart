import 'package:flutter/material.dart';
import 'package:memo/models/note.dart';
import 'package:memo/service/noteBloc.dart';
import 'package:memo/widgets/homeWidget.dart';
import 'package:memo/widgets/noteWIdget.dart';

class BookmarkPage extends StatefulWidget {
  NoteBloc bloc;
  BookmarkPage({this.bloc});

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  NoteBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    bloc = widget.bloc;
    bloc.getBookmarkedNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        children: <Widget>[
          Container(),
          Container(
            child: StreamBuilder<List<Note>>(
              stream: bloc.bookmarkedNoteStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    child: Center(
                      child: Text("ノートを作成しよう"),
                    ),
                  );
                } else {
                  return Column(
                    children: snapshot.data.map((data) {
                      return Row(
                        children: <Widget>[
                          noteCard(bloc,context,data)
                        ],
                      );  
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
