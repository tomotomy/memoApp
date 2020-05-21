import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final weeks = ["日","月", "火","水", "木", "金","土"];
  DateTime date;
  DateTime minDate;
  DateTime maxDate;
  List<DateTime> dateList;
  List<DateTime> _weeks = List();
  PageController controller;
  GlobalKey key = GlobalKey();


  static DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? new DateTime(month.year, month.month + 1, 1)
        : new DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }

  @override
  void initState() {
    // TODO: implement initState
    minDate = DateTime(2019);
    maxDate = DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
    _weeks = [DateTime.now()];
    super.initState();
  }

  List<Widget> _buildDayTile(DateTime month) {
    List<Widget> items = [];
    final lastDay = lastDayOfMonth(month).day.toInt();
    final firstDay = DateTime(month.year, month.month, 1);
    print(firstDay.weekday);
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
    return Center(
      child: Text(date.day.toString()),
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

  Widget calendarCard(int index) {
    print(index);
    final date = DateTime(DateTime.now().year, DateTime.now().month - (11 - index));
    return Container(
      margin: EdgeInsets.all(5),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  date.year.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54
                  ),
                ),
              ),
              Center(
                child: Text(
                  "${date.month.toString()}月",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black87
                  ),
                ),
              ),
              SizedBox(height: 10,),
              weekLable(),
              calendarBody(date),
            ],
          ),
        ),
      ),
    );
  }

  Widget calendarCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        height: 450,
      ),
      items: _weeks.map((week) {
        
      }).toList()
    );
  }

  Widget carousel() {
    return Container(
      height: 450,
      child: PageView.builder(
        itemCount: 12,
        itemBuilder: (context, index) {
          return calendarCard(index);
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return carousel();
  }
}