import 'package:flutter/material.dart';
import 'package:memo/memoIndex.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.import_contacts),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return MemoIndex();
              }
            )
          );
        },
      ),
    );
  }
}