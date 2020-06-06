import 'package:flutter/material.dart';
import 'package:memo/memoForm.dart';
import 'package:memo/memoList.dart';
import 'package:memo/models/note.dart';
import 'package:memo/service/DBProvider.dart';
import 'package:memo/service/memoBloc.dart';
import 'package:memo/service/noteBloc.dart';
import 'package:provider/provider.dart';

class MemoIndex extends StatefulWidget {
  final String initTab;
  final NoteBloc noteBloc;
  final Note note;
  MemoIndex({
    this.initTab,
    this.noteBloc,
    this.note,
  });

  @override
  _MemoIndexState createState() => _MemoIndexState();
}

class _MemoIndexState extends State<MemoIndex> with SingleTickerProviderStateMixin {
  @override
  TextEditingController _textFieldController = TextEditingController();
  TabController _tabController;
  String title;
  MemoBloc memoBloc;
  String type;
  final List<String> tabText = [
    "事象",
    "抽象",
    "転用",
  ];

  final List<Tab> tabs = <Tab>[
    Tab(text: "事象",),
    Tab(text: "抽象",),
    Tab(text: "転用",)
  ];

  void initState() {
    super.initState();
    memoBloc = MemoBloc();
    _tabController = TabController(length: tabs.length, vsync: this);
    setStream();
    _tabController.addListener(setStream);
    title = widget.note != null ? widget.note.title : "未設定";
    if (widget.initTab != null) {
      _tabController.index = tabText.indexOf(widget.initTab);
    }
  }

  void setStream() {
    type = tabText[_tabController.index];
    memoBloc.getMemos(type: type, noteId: widget.note.id);
  }

  void setTitle() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('タイトル設定'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(
              hintText: widget.note != null ? widget.note.title : "未設定"
            ),
          ), 
          actions: <Widget>[
            new FlatButton(
              child: new Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton( 
              child: Text("OK"),
              onPressed: () {
                if (_textFieldController.text != null) {
                  setState(() {
                    title = _textFieldController.text;
                  });
                  widget.noteBloc.update(Note(
                    id: widget.note.id,
                    date: widget.note.date,
                    title: _textFieldController.text,
                  ));
                }
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  Widget _createTab(Tab tab){
    return Center(
      child: Text("10 min Rest Time" , style: TextStyle(
        fontSize: 24.0
      ),),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black54
          ),
        ) ,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black54),
        bottom: TabBar(
          tabs: tabs,
          controller: _tabController,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 2,
          indicatorPadding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 8),
          labelColor: Colors.black,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setTitle();
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabText.map((tab) {
          return MemoList(
            type: tab,
            noteId: widget.note.id,
            note: widget.note,
            memoBloc: memoBloc,
            noteBloc: widget.noteBloc,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MemoForm(
                type: type,
                noteId: widget.note.id,
                note: widget.note,
                noteBloc: widget.noteBloc,
                memoBloc: memoBloc,
              ),
            )
          );
        },
      ),
    );
  } 
}