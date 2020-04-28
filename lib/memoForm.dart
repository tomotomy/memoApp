import 'package:flutter/material.dart';
import 'package:memo/memoIndex.dart';
import 'package:memo/models/memo.dart';
import 'package:memo/service/memoBloc.dart';

class MemoForm extends StatefulWidget {
  String type;
  MemoForm({this.type});

  @override
  _MemoFormState createState() => _MemoFormState();
}

class _MemoFormState extends State<MemoForm> {
  final _formKey = GlobalKey<FormState>();
  final bloc = MemoBloc();
  String _content;
  String _title;
  String _type;
  String _labelColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void saveMemo() {
    if (_content != null) {
      bloc.create(
        Memo(
          title: "test",
          contents: _content,
          type: widget.type,
          labelColor: "red",
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black54
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              saveMemo();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MemoIndex(initTab: widget.type,),
                )
              );
            },
          ),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:10, right: 5, left: 5),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  maxLines: 100,
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
    );
  }
}