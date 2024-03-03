import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routine_quality_tracker/device_size.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDateTime extends StatefulWidget {
  const CustomDateTime({super.key});

  @override
  State<CustomDateTime> createState() => _CustomDateTimeState();
}

class _CustomDateTimeState extends State<CustomDateTime> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DeviceSize.width(context, partNumber: 10),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(62, 55, 81, 1),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM yyyy').format(dateTime),
                style: const TextStyle(
                    color: Color.fromRGBO(227, 126, 126, 1),
                    fontSize: 25,
                    fontWeight: FontWeight.w700),
              ),
              Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color: const Color.fromRGBO(227, 126, 126, 1),
                      onPressed: () {
                        setState(() {
                          dateTime =
                              DateTime(dateTime.year, dateTime.month - 1);
                        });
                      }),
                  IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      color: const Color.fromRGBO(227, 126, 126, 1),
                      onPressed: () {
                        setState(() {
                          dateTime =
                              DateTime(dateTime.year, dateTime.month + 1);
                        });
                      })
                ],
              )
            ],
          ),
          TableCalendar(
              focusedDay: dateTime,
              firstDay: DateTime(2018),
              lastDay: DateTime(2100),
              currentDay: DateTime.now(),
              headerVisible: false,
              daysOfWeekHeight: 32,
              daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: Color.fromRGBO(252, 221, 236, 1),
                    fontSize: 18,
                  ),
                  weekendStyle: TextStyle(
                    color: Color.fromRGBO(243, 106, 106, 1),
                    fontSize: 18,
                  )),
              calendarStyle: const CalendarStyle(
                  defaultTextStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                  weekendTextStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              onDaySelected: (date, date2) {
                setState(() {
                  dateTime = date2;
                });
              }),
        ],
      ),
    );
  }

  get getDateTime => dateTime;
}

showCustomDateDiaglog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
              width: DeviceSize.width(context, partNumber: 10),
              height: DeviceSize.height(context, partNumber: 5) + 50,
              child: const CustomDateTime())));
}
