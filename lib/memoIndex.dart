import 'package:flutter/material.dart';
import 'package:memo/memoForm.dart';
import 'package:memo/memoList.dart';
import 'package:memo/models/note.dart';
import 'package:memo/service/DBProvider.dart';

class MemoIndex extends StatefulWidget {
  final String initTab;
  MemoIndex({this.initTab});

  @override
  _MemoIndexState createState() => _MemoIndexState();
}

class _MemoIndexState extends State<MemoIndex> with SingleTickerProviderStateMixin {
  @override
  TabController _tabController;
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
    _tabController = TabController(length: tabs.length, vsync: this);
    if (widget.initTab != null) {
      _tabController.index = tabText.indexOf(widget.initTab);
    }
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
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabText.map((tab) {
          return MemoList(type: tab);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          DBProvider.db.newNote(
            Note(),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MemoForm(type: tabText[_tabController.index],),
            )
          );
        },
      ),
    );
  } 
}