import 'package:flutter/material.dart';
import 'package:memo/BookmarkPage.dart';
import 'package:memo/calendar.dart';
import 'package:memo/functions/DateToString.dart';
import 'package:memo/memoIndex.dart';
import 'package:memo/models/note.dart';
import 'package:memo/service/noteBloc.dart';
import 'package:memo/widgets/homeWidget.dart';
import 'package:memo/widgets/noteWIdget.dart';


class Home extends StatelessWidget {

  Widget drawer(BuildContext context, NoteBloc bloc) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return BookmarkPage(bloc: bloc,);
                }
              ));
            },
            contentPadding: EdgeInsets.all(10),
            title: Text(
              "保存済みのノート",
              style: TextStyle(fontSize: 20),
            ),
            leading: Icon(
              Icons.bookmark,
              size: 40,
            ),
          )
        ],
      ),
    );
  }

  Widget createNoteButton(BuildContext context, NoteBloc bloc) {
    return  FloatingActionButton(
      child: Icon(Icons.import_contacts),
      onPressed: () {
        final date = dateToString(DateTime.now());
        final note = bloc.create(
          Note(
            title: "未設定",
            date: date,
            point: 0,
            isBookmarked: false,
          )
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return MemoIndex(
                bloc: bloc,
                note: note
              );
            }
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = dateToString(DateTime.now());
    final bloc = NoteBloc(date: date);
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(context, bloc),
      floatingActionButton: createNoteButton(context, bloc),
      body: ListView(
        children: <Widget>[
          Calendar(bloc: bloc,),
          Container(
            child: StreamBuilder<List<Note>>(
              stream: bloc.noteStream,
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
      )
    );
  }
}