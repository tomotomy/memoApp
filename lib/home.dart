import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:memo/BookmarkPage.dart';
import 'package:memo/functions/DateToString.dart';
import 'package:memo/memoIndex.dart';
import 'package:memo/models/note.dart';
import 'package:memo/service/DBProvider.dart';
import 'package:memo/service/noteBloc.dart';


class Home extends StatelessWidget {
  final bloc = NoteBloc();

  Widget bookmarkButton(Note data) {
    return IconButton(
      icon: Icon(
        data.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: Colors.black54,
      ),
      iconSize: 40,
      onPressed: () {
        bloc.update(
          Note(
            id: data.id,
            date: data.date,
            title: data.title,
            point: data.point,
            isBookmarked: !data.isBookmarked,
          )
        );
      },
    );
  }

  Widget noteCard(BuildContext context,Note data) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return MemoIndex(
                  note: data,
                  bloc: bloc,
                );
              }
            )
          );
        },
        child: Card(
          elevation: 10,
          child: Container(
            width: 200,
            padding: EdgeInsets.all(10),
            height: 100,
            child: Row(
              children: <Widget>[
                bookmarkButton(data),
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return BookmarkPage();
                }
              ));
            },
            contentPadding: EdgeInsets.all(10),
            title: Text("保存済みのノート"),
            leading: Icon(Icons.bookmark),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
      ),
      drawer: drawer(context),
      floatingActionButton: createNoteButton(context),
      body: ListView(
        children: <Widget>[
          Container(),
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
                          noteCard(context, data)
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