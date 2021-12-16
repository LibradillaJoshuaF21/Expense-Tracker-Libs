import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/widgets/progress_bar.dart';

class TransDayInfo extends StatefulWidget {
  final double totalExpense;
  final double expense;
  final String dayName;
  TransDayInfo({
    Key? key,
    required this.totalExpense,
    required this.expense,
    required this.dayName,
  }) : super(key: key);

  @override
  _TransDayInfoState createState() => _TransDayInfoState();
}

class _TransDayInfoState extends State<TransDayInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //Graph with Title Amount, Bar, and Day Name
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              // Content: Title Amount
              NumberFormat.simpleCurrency(locale: 'fil').format(widget.expense),
              style: TextStyle(
                fontSize: 11,
              ),
            ),
            ProgressBar(
              // Content: Bar
              totalExpense: widget.totalExpense,
              expense: widget.expense,
            ),
            Text(
              // Content: Day Name
              getDayName(widget.dayName),
              style: TextStyle(
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getDayName(String dayName) {
    // Function that returns the shorten day names
    String newDayName = '';
    switch (dayName) {
      case 'Monday':
        newDayName = 'Mon';
        break;
      case 'Tuesday':
        newDayName = 'Tue';
        break;
      case 'Wednesday':
        newDayName = 'Wed';
        break;
      case 'Thursday':
        newDayName = 'Thu';
        break;
      case 'Friday':
        newDayName = 'Fri';
        break;
      case 'Saturday':
        newDayName = 'Sat';
        break;
      case 'Sunday':
        newDayName = 'Sun';
        break;
      default:
        newDayName = 'null';
    }
    return newDayName;
  }
}
