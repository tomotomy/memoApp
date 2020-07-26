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
      body: StreamBuilder<List<Note>>(
        stream: bloc.bookmarkedNoteStream,
        builder: (context, snapshot) {
          print(snapshot.data);
          if (!snapshot.hasData || snapshot.data.length == 0) {
            return Container(
              child: Center(
                child: Text("日々のノートを保存しよう"),
              ),
            );
          } else {
            return Column(
              children: snapshot.data.map((data) {
                return noteCard(bloc,context,data);  
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
