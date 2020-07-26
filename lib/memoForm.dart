import 'dart:math';

import 'package:flutter/material.dart';
import 'package:memo/functions/StringToColor.dart';
import 'package:memo/memoIndex.dart';
import 'package:memo/models/memo.dart';
import 'package:memo/models/note.dart';
import 'package:memo/service/memoBloc.dart';
import 'package:memo/service/noteBloc.dart';


class MemoForm extends StatefulWidget {
  String type;
  String noteId;
  Memo memo;
  Note note;
  MemoBloc memoBloc;
  NoteBloc noteBloc;
  int color;
  MemoForm({
    this.type, 
    this.memo,
    this.color,
    @required this.note,
    @required this.noteId,
    @required this.memoBloc,
    @required this.noteBloc,
  });

  @override
  _MemoFormState createState() => _MemoFormState();
}

class _MemoFormState extends State<MemoForm> {
  final _formKey = GlobalKey<FormState>();
  String _content;
  String _title;
  String _type;
  int _labelColor;

  @override
  void initState() {
    if (widget.memo != null) {
      _content = widget.memo.contents;
      _title = widget.memo.title;
      _labelColor = widget.memo.labelColor;
    } else if (widget.color != null) {
      _labelColor = widget.color;
    } else {
      _labelColor = Random().nextInt(Colors.primaries.length);
    }
    // TODO: implement initState
    super.initState();
  }

  void saveMemo() {
    if (_content != null) {
      if (widget.memo != null) {
        updateMemo();
      } else {
        createMemo();
      }
      updateNoteNumber();
    }
  }

  void changeColor() {
    setState(() {
      _labelColor = Random().nextInt(Colors.primaries.length);
    });
  }

  void createMemo() {
    widget.memoBloc.create(
      Memo(
        title: _title,
        noteId: widget.noteId,
        contents: _content,
        type: widget.type,
        labelColor: _labelColor,
      ),
      widget.type,
    );
  }

  void updateMemo() {
    widget.memoBloc.update(
      Memo(
        id: widget.memo.id,
        noteId: widget.memo.noteId,
        type: widget.memo.type,
        title: _title,
        contents: _content,
        labelColor: _labelColor,
      ),
      widget.memo.type,
    );
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
        matter: widget.type == '事象' ? (widget.note.matter + 1) : widget.note.matter,
        abstraction: widget.type == '抽象' ? (widget.note.abstraction + 1) : widget.note.abstraction,
        diversion: widget.type == '転用' ? (widget.note.diversion + 1) : widget.note.diversion, 
        totalPoint: widget.note.totalPoint + point,
      )
    );
  }

Widget colorButton(String colorString, Color color) {
  return SimpleDialogOption(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.1449,
      height: MediaQuery.of(context).size.height * 0.066,
      child: MaterialButton(
        shape: CircleBorder(
            side:
                BorderSide(width: 2, color: color, style: BorderStyle.solid)),
        color: color,
        onPressed: () {
          setState(() {

          });
          Navigator.pop(context);
        },
      ),
    ),
  );
}

Widget floatingActionButton() {
  return FloatingActionButton.extended(
    label: Text(
      widget.type == "事象" ? "抽象化" : "転用",
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 20
      ),
    ),
    onPressed: () {
      saveMemo();
      Navigator.pushReplacement(context, 
        MaterialPageRoute(builder: (context) => MemoForm(
          memoBloc: widget.memoBloc,
          noteBloc: widget.noteBloc,
          type: widget.type == "事象" ? "抽象" : "転用",
          note: widget.note,
          noteId: widget.noteId,
          color: _labelColor,
        ))
      );
    },
  );
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.type != "転用" 
      ? floatingActionButton() : Container(),
      body: Material(
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black54
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.color_lens),
                onPressed: () {
                  changeColor();
                },
              )
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                saveMemo();
                Navigator.pop(context);
              },
            ),
          ),
          body: ListView(
            children: <Widget>[
              SizedBox(
                height: 20,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.primaries[_labelColor],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:10, right: 5, left: 5),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 20
                    ),
                    maxLines: 100,
                    initialValue: _content,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),                  
                    ),
                    autofocus: true,
                    onChanged: (value) {
                      setState(() => _content = value);
                    },
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}