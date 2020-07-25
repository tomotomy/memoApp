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
  String color;
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
  String _labelColor;
  Color barColor;

  @override
  void initState() {
    if (widget.memo != null) {
      _content = widget.memo.contents;
      _title = widget.memo.title;
      _labelColor = widget.memo.labelColor;
      barColor = stringToColor(widget.memo.labelColor);
    } 
    if (widget.color != null) {
      _labelColor = widget.color;
      barColor = stringToColor(_labelColor);
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

  Future<void> colorChangeDialog() async {
    await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Wrap(
                      runSpacing: -5,
                      spacing: -30,
                      direction: Axis.horizontal,
                      children: <Widget>[
                        colorButton('redAccent', Colors.redAccent),
                        colorButton('pinkAccent', Colors.pinkAccent),
                        colorButton('orangeAccent', Colors.orangeAccent),
                        colorButton('yellow', Colors.yellow),
                        colorButton('greenAccent', Colors.greenAccent),
                        colorButton('tealAccent', Colors.tealAccent[400]),
                        colorButton('lightBlueAccent', Colors.lightBlueAccent),
                        colorButton('indigoAccent', Colors.indigoAccent),
                        colorButton('deepPurple', Colors.deepPurple[300])
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, 2),
                    child: const Text('キャンセル'),
                  )
                ],
              ),
            )
          ],
        );
      },
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
            _labelColor = colorString;
            barColor = color;
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
                  colorChangeDialog();
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
                    color: barColor,
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