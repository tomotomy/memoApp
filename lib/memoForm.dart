import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class MemoForm extends StatefulWidget {
  @override
  _MemoFormState createState() => _MemoFormState();
}

class _MemoFormState extends State<MemoForm> {
  final _formKey = GlobalKey<FormState>();
  String _content;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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