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
  List<List<DateTime>> _weeks = List();



  List<DateTime> _getDaysInWeek([DateTime selectedDate]) {
    if (selectedDate == null) selectedDate = new DateTime.now();

    var firstDayOfCurrentWeek = _firstDayOfWeek(selectedDate);
    var lastDayOfCurrentWeek = _lastDayOfWeek(selectedDate);

    return _daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
        .toList();
  }

  DateTime _firstDayOfWeek(DateTime date) {
    var day = _createUTCMiddayDateTime(date);
    return day.subtract(new Duration(days: date.weekday % 7));
  }

  DateTime _lastDayOfWeek(DateTime date) {
    var day = _createUTCMiddayDateTime(date);
    return day.add(new Duration(days: 7 - day.weekday % 7));
  }

  DateTime _createUTCMiddayDateTime(DateTime date) {
    // Magic const: 12 is to maintain compatibility with date_utils
    return new DateTime.utc(date.year, date.month, date.day, 12, 0, 0);
  }

  Iterable<DateTime> _daysInRange(DateTime start, DateTime end) {
    var offset = start.timeZoneOffset;

    return List<int>.generate(end.difference(start).inDays, (i) => i + 1)
      .map((int i) {
      var d = start.add(Duration(days: i - 1));

      var timeZoneDiff = d.timeZoneOffset - offset;
      if (timeZoneDiff.inSeconds != 0) {
        offset = d.timeZoneOffset;
        d = d.subtract(new Duration(seconds: timeZoneDiff.inSeconds));
      }
      return d;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    minDate = DateTime(2019);
    maxDate = DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);


    date = DateTime.now();
    for (int _cnt = 0;
    0 >= minDate.add(Duration(days: 7 * _cnt)).difference(maxDate.add(Duration(days: 7))).inDays;
    _cnt++) {
      _weeks.add(_getDaysInWeek(minDate.add(new Duration(days: 7 * _cnt))));
    }
    super.initState();
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
                ? TextStyle(
                  color: Colors.black54
                )
                : TextStyle(
                  color: index == 0 ? Colors.redAccent : Colors.blueAccent
                )  
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget calendarTile(String text) {
    return Center(
      child: Text(text),
    );
  }

  Widget calendarBody() {
    return Container(
      height: 200,
      child: GridView.count(
        crossAxisCount: 7,
        children: dateList.map((date) {
          return Center(
            child: Text(date.day.toString()),
          );
        }).toList()
      ),
    );  
  }

  Widget calendarCarousel(double width) {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        height: 300
      ),
      items: _weeks.map((week) {
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
                  // calendarBody(),
                ],
              ),
            ),
          ),
        );
      }).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final width = MediaQuery.of(context).size.width;
    return calendarCarousel(width);
  }
}