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
    return Expanded(
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
        child: Card(
          elevation: 10,
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
    );
  }