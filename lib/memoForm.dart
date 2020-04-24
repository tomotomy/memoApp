import 'package:flutter/material.dart';
import 'package:memo/service/DBProvider.dart';
import 'package:uuid/uuid.dart';

import 'models/memo.dart';

class MemoForm extends StatefulWidget {
  @override
  _MemoFormState createState() => _MemoFormState();
}

class _MemoFormState extends State<MemoForm> {
  final _formKey = GlobalKey<FormState>();
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
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              saveMemo();
              Navigator.of(context).pop();
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
                    setState(() => _content == value);
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