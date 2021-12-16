import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/models/day_expense_model.dart';
import 'package:personal_expense_tracker/models/transaction_model.dart';
import 'package:personal_expense_tracker/widgets/transaction_day_info.dart';

// ignore: must_be_immutable
class BarChartSample extends StatefulWidget {
  List<TransModel> transList =
      <TransModel>[]; // Receives the list of transactions
  List<DayExpense> expenseList =
      <DayExpense>[]; // Receives the expense per day list
  BarChartSample({
    Key? key,
    required this.transList,
    required this.expenseList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BarChartSampleState();
}

class _BarChartSampleState extends State<BarChartSample> {
  DateTime selectedDate = DateTime.now();
  double totalExpense = 0.0;

  @override
  Widget build(BuildContext context) {
    if (widget.expenseList.length != 7) {
      generateDayList(); // Populates the expense list with the relevant dates and setting their expenses to 0
    }
    totalExpense = getTotalExpense(widget
        .transList); // Calculates Total Expenses by adding all expenses in every transactions in transaction list
    getExpense(widget
        .transList); // Gets the expense in every transaction and adding to matched days in expense list
    return Container(
      // Bar Chart
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: 500,
          height: 100,
          child: Card(
            elevation: 5,
            color: Colors.white,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                //Builds the individual graphs (title, bar, and day)
                buildGraph(totalExpense, widget.expenseList[6].expenseDay,
                    widget.expenseList[6].dayName),
                buildGraph(totalExpense, widget.expenseList[5].expenseDay,
                    widget.expenseList[5].dayName),
                buildGraph(totalExpense, widget.expenseList[4].expenseDay,
                    widget.expenseList[4].dayName),
                buildGraph(totalExpense, widget.expenseList[3].expenseDay,
                    widget.expenseList[3].dayName),
                buildGraph(totalExpense, widget.expenseList[2].expenseDay,
                    widget.expenseList[2].dayName),
                buildGraph(totalExpense, widget.expenseList[1].expenseDay,
                    widget.expenseList[1].dayName),
                buildGraph(totalExpense, widget.expenseList[0].expenseDay,
                    widget.expenseList[0].dayName),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  double getTotalExpense(List<TransModel> transList) {
    // Returns the total expense after going through all transactions, returns 0 if there are no transctions
    var totalExpense = 0.0;
    for (TransModel trans in transList) {
      totalExpense = totalExpense + trans.expense;
    }
    return totalExpense;
  }

  void generateDayList() {
    // Gets the current day and populates the days in expense list while setting each expense to 0
    DateTime selectedDate = DateTime.now();
    setState(() {
      for (int i = 0; i < 7; i++) {
        widget.expenseList.add(DayExpense(
            expenseDay: 0, dayName: DateFormat('EEEE').format(selectedDate)));
        selectedDate = new DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day -
                1); // Subtracts a day to the current date to get the previous day
      }
    });
  }

  void getExpense(List<TransModel> transList) {
    // Gets the expenses in every transaction and adds them to expense list via matching dates
    if (transList.isNotEmpty) {
      setState(
        () {
          for (TransModel trans in transList) {
            var transDay = DateFormat('EEEE').format(trans
                .transDate!); // Stores the day name of the transaction date
            for (int i = 0; i < 7; i++) {
              if (transDay == widget.expenseList[i].dayName) {
                // Checks the expense list for matching day name
                if (trans.isAdded == false) {
                  widget.expenseList[i].expenseDay =
                      widget.expenseList[i].expenseDay + trans.expense;
                  trans.isAdded = true;
                }
              }
            }
          }
        },
      );
    }
  }

  Widget buildGraph(double totalExpense, double expense,
          String dayName) => // Widget to build the Individual Graphs
      TransDayInfo(
          totalExpense: totalExpense, expense: expense, dayName: dayName);
}
