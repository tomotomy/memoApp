import 'package:flutter/material.dart';
import 'package:memo/BookmarkPage.dart';
import 'package:memo/functions/DateToString.dart';
import 'package:memo/memoIndex.dart';
import 'package:memo/models/note.dart';
import 'package:memo/service/noteBloc.dart';
import 'package:memo/widgets/homeWidget.dart';
import 'package:memo/widgets/noteWIdget.dart';


class Home extends StatelessWidget {
  final bloc = NoteBloc();

  Widget drawer(BuildContext context) {
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

  Widget createNoteButton(BuildContext context) {
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

  Widget calendar() {
    final today = DateTime.now();
    return Container(
      margin: EdgeInsets.all(5),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  today.year.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54
                  ),
                ),
              ),
              Center(
                child: Text(
                  "${today.month.toString()}月",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(context),
      floatingActionButton: createNoteButton(context),
      body: ListView(
        children: <Widget>[
          calendar(),
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