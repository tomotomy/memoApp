import 'package:flutter/material.dart';
import 'package:memo/memoIndex.dart';
import 'package:memo/models/note.dart';
import 'package:memo/service/noteBloc.dart';

Widget bookmarkButton(NoteBloc bloc, Note data) {
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
            isBookmarked: !data.isBookmarked,
          )
        );
      },
    );
  }

  Widget noteCard(NoteBloc bloc,BuildContext context,Note data) {
    return Container(
      width: double.infinity,
      child: Dismissible(
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
        child: Card(
          elevation: 10,
          child: Container(
            width: double.infinity,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return MemoIndex(
                        note: data,
                        noteBloc: bloc,
                      );
                    }
                  )
                );
              },
              child: Container(
                width: 200,
                padding: EdgeInsets.all(10),
                height: 100,
                child: Row(
                  children: <Widget>[
                    bookmarkButton(bloc, data),
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
        ),
      ),
    );
  }