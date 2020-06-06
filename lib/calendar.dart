import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:memo/functions/DateToString.dart';
import 'package:memo/models/note.dart';
import 'package:memo/service/noteBloc.dart';
import 'package:badges/badges.dart';

class Calendar extends StatefulWidget {
  Calendar({@required this.bloc, @required this.pointData});

  final NoteBloc bloc;
  final Map<String, int> pointData;

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final weeks = ["日","月", "火","水", "木", "金","土"];
  DateTime date;
  DateTime minDate;
  DateTime maxDate;
  DateTime selectedDate;
  List<DateTime> dateList;
  PageController controller;


  static DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? new DateTime(month.year, month.month + 1, 1)
        : new DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }

  Color backgroundColor(int point) {
    if (point == null || point == 0) {
      return null;
    } else if (point >= 10) {
      return Colors.lightBlue[900];
    }
    switch (point) {
      case 1 :
        return Colors.lightBlue[50];
      case 2 : 
        return Colors.lightBlue[100];
      case 3 : 
        return Colors.lightBlue[200];
      case 4 : 
        return Colors.lightBlue[300];
      case 5 : 
        return Colors.lightBlue[400];
      case 6 : 
        return Colors.lightBlue;
      case 7 : 
        return Colors.lightBlue[600];
      case 8 :
        return Colors.lightBlue[700];
      case 9 : 
        return Colors.lightBlue[800];
      default : 
        return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = DateTime.now();
    minDate = DateTime(2019);
    maxDate = DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
    controller = PageController(initialPage: 12);
  }

  void setMonthNotesStream(int index) {
    final month = DateTime(DateTime.now().year, DateTime.now().month - (11 - index));
    widget.bloc.getMonthNotes(month);
  }

  void setStream(String date) {
    widget.bloc.getNotes(date);
  }

  void setDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  List<Widget> _buildDayTile(DateTime month) {
    List<Widget> items = [];
    final lastDay = lastDayOfMonth(month).day.toInt();
    final firstDay = DateTime(month.year, month.month, 1);
    for (int i = 0; i < firstDay.weekday; i++) {
      if(firstDay.weekday == 7) {
        break;
      }
      items.add(Text(""));
    }
    for (int i = 1; i <= lastDay; i++) {
      final day = DateTime(month.year, month.month, i);
      items.add(calendarTile(day));
    }
    return items;
  }

  Widget weekLable() {
    return Row(
      children: weeks.map((item) {
        final index = weeks.indexOf(item);
        return Expanded(
          child: Center(
            child: Text(
              item,
              style: index != 0 || index != 6 
                ? TextStyle( color: Colors.black54)
                : TextStyle(color: index == 0 ? Colors.redAccent : Colors.blueAccent)  
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget calendarTile(DateTime date) {
    final stringDate = dateToString(date);
    bool isSame = (stringDate == dateToString(selectedDate)); 
    bool isAfter = (date.isAfter(DateTime.now()));
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isAfter ? Colors.grey[100] : backgroundColor(widget.pointData[stringDate])
          ),
          child: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
            ),
            child: InkWell(
              onTap: () {
                if (!isAfter) {
                  final stringDate = dateToString(date);
                  setDate(date);
                  setStream(stringDate);
                }
              },
              child: Center(
                child: Text(date.day.toString()),
              ),
            ),
          ),
        ),
        Container(
          child: isSame 
          ? Badge(badgeColor: Colors.tealAccent,)
          : Container()
        )
      ],
    );
  }

  Widget calendarBody(DateTime date) {
    return GridView.count(
     physics: NeverScrollableScrollPhysics(),
     crossAxisCount: 7,
     shrinkWrap: true,
     children: _buildDayTile(date)
    );  
  }

  Widget calendarYear(DateTime date) {
    return Center(
      child: Text(
        date.year.toString(),
        style: TextStyle(
          fontSize: 18,
          color: Colors.black54
        ),
      ),
    );
  }

  Widget calendarMonth(DateTime date) {
    return Center(
      child: Text(
        "${date.month.toString()}月",
        style: TextStyle(
          fontSize: 24,
          color: Colors.black87
        ),
      ),
    );
  }

  Widget calendarCard(int index) {
    final date = DateTime(DateTime.now().year, DateTime.now().month - (11 - index));
    return Container(
      margin: EdgeInsets.all(5),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              calendarYear(date),
              calendarMonth(date),
              SizedBox(height: 10,),
              weekLable(),
              calendarBody(date),
            ],
          ),
        ),
      ),
    );
  }

  Widget carousel() {
    return Container(
      height: 450,
      child: PageView.builder(
        controller: controller,
        itemCount: 12,
        itemBuilder: (context, index) {
          return calendarCard(index);
        },
        onPageChanged: (index) {
          setMonthNotesStream(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.pointData['2020-06-06']);
    return carousel();
  }
}