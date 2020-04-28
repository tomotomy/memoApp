import 'package:flutter/material.dart';
import 'package:memo/functions/DateToString.dart';
import 'package:memo/memoIndex.dart';
import 'package:memo/models/note.dart';
import 'package:memo/service/DBProvider.dart';
import 'package:memo/service/noteBloc.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final bloc = NoteBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.import_contacts),
        onPressed: () {
          final date = dateToString(DateTime.now());
          bloc.create(
            Note(
              title: "未設定",
              date: date,
              point: 0,
            )
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return MemoIndex();
              }
            )
          );
        },
      ),
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
                      return Card(
                        child: Text(data.title),
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