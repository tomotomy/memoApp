import 'package:flutter/material.dart';

class MemoIndex extends StatefulWidget {
  @override
  _MemoIndexState createState() => _MemoIndexState();
}

class _MemoIndexState extends State<MemoIndex> {
  @override

  Widget sideLabel(String text) {
    return Expanded(
      flex: 12,
      child: Container(
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    double height = MediaQuery. of(context). size. height - Scaffold.of(context).appBarMaxHeight;
    return Column(
      children: <Widget>[
        Container(
          height: height / 3.3,
          child: Row(
            children: <Widget>[
              sideLabel("事\n象"),
              VerticalDivider(),
              Expanded(
                flex: 100,
                child: ListView(
                  children: <Widget>[
                    Container(
                      
                    )
                  ],
                ),
              ),
            ],
          )
        ),
        Container(
          height: height / 3.3,
          child: Row(
            children: <Widget>[
              sideLabel("抽\n象"),
              VerticalDivider(),
              Expanded(
                flex: 100,
                child: ListView(
                  children: <Widget>[
                    Container(
                      
                    )
                  ],
                ),
              ),
            ],
          )
        ),
        Container(
          height: height / 3.3,
          child: Row(
            children: <Widget>[
              sideLabel("転\n用"),
              VerticalDivider(),
              Expanded(
                flex: 100,
                child: ListView(
                  children: <Widget>[
                    Container(
                      
                    )
                  ],
                ),
              ),
            ],
          )
        )
      ],
    );
  }
}