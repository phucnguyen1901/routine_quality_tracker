import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routine_quality_tracker/device_size.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDateTime extends StatefulWidget {
  const CustomDateTime(
      {super.key, required this.callback, required this.newDateTime});
  final Function(DateTime) callback;
  final DateTime newDateTime;

  @override
  State<CustomDateTime> createState() => _CustomDateTimeState();
}

class _CustomDateTimeState extends State<CustomDateTime> {
  DateTime dateTime = DateTime.now();
  @override
  void initState() {
    dateTime = widget.newDateTime;
    super.initState();
  }

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
            currentDay: dateTime,
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
                defaultTextStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                weekendTextStyle: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            onDaySelected: (date, date2) {
              setState(() {
                dateTime = date2;
                widget.callback(dateTime);
              });
            },
          ),
        ],
      ),
    );
  }
}

Future<DateTime> showCustomDateDialog(
    BuildContext context, DateTime date) async {
  DateTime dateTime = DateTime.now();

  await showDialog<DateTime>(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: DeviceSize.width(context, partNumber: 10),
        height: DeviceSize.height(context, partNumber: 5) + 50,
        child: CustomDateTime(
            newDateTime: date,
            callback: (DateTime newDateTime) {
              dateTime = newDateTime;
            }),
      ),
    ),
  );
  return dateTime;
}
