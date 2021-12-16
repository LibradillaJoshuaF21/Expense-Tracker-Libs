import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/models/transaction_model.dart';
import 'package:personal_expense_tracker/not_found.dart';
import 'package:personal_expense_tracker/widgets/barchart.dart';
import 'package:personal_expense_tracker/widgets/input_sheet.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'models/day_expense_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Expense Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = PageController(
    initialPage: 0,
  );
  static List<TransModel> transList = <
      TransModel>[]; // List containing all transactions(title, expense, and day)
  static List<DayExpense> expenseList =
      <DayExpense>[]; // List containing total expenses per day

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: showBottomInputSheet, // Shows bottom sliding input form
                child: Icon(
                  Icons.add,
                  size: 26.0,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              BarChartSample(
                // Generates the Bar Chart
                transList: transList,
                expenseList: expenseList,
              ),
              transList.isEmpty // Checks if there are no transactions
                  ? NoTrans() // No Transactions Found
                  : Expanded(
                      // Generates List of Transactions
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: controller,
                        children: [
                          Container(
                            child: ListView(
                              key: Key(transList.length.toString()),
                              children:
                                  List.generate(transList.length, (index) {
                                return buildTransCard(
                                  // Builds the Transaction Cards
                                  transList[index].expense,
                                  transList[index].title,
                                  transList[index].transDate!,
                                  transList[index],
                                  transList,
                                  expenseList,
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: showBottomInputSheet, // Shows bottom sliding input form
          tooltip: 'Add New Transaction',
          backgroundColor: Colors.yellow[700],
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void showBottomInputSheet() async {
    // Activates the bottom sliding form
    // ignore: unused_local_variable
    final result = await showSlidingBottomSheet(
      // result waits for inputs after bottom sliding input form closes/submits
      context,
      builder: (context) {
        return SlidingSheetDialog(
          elevation: 8,
          cornerRadius: 16,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [0.4, 0.7, 1.0],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          builder: (context, state) {
            return InputSheet(); // Generates the content of the bottom sliding form
          },
        );
      },
    );
    if (result != null) {
      // Only adds inputs to transactions if form is submitted with valid inputs
      addTransaction(result); // Adds input to transaction list
    }
  }

  void addTransaction(TransModel transaction) {
    // Adds transaction data received to list of transactions
    setState(() {
      transList.add(transaction);
    });
  }

  Widget buildTransCard(
    // Builds the Transaction Card being displayed
    double expense,
    String title,
    DateTime dateTime,
    TransModel transaction,
    List<TransModel> transList,
    List<DayExpense> expenseList,
  ) =>
      Container(
        // Transaction Card
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: 80,
            child: Card(
              elevation: 5,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      // Content: Amount enclosed with Circle Container
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            NumberFormat.simpleCurrency(locale: 'fil')
                                .format(expense),
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // Content: Title of Transaction
                      width: 240,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                DateFormat.yMMMMd('en_US').format(dateTime),
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      // Content: Remove Icon with functionality
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        child: Icon(
                          Icons.delete,
                          size: 26.0,
                          color: Colors.red,
                        ),
                        onTap: () {
                          setState(() {
                            var transDay = DateFormat('EEEE')
                                .format(transaction.transDate!);
                            for (int i = 0; i < 7; i++) {
                              if (transDay == expenseList[i].dayName) {
                                expenseList[i].expenseDay =
                                    expenseList[i].expenseDay -
                                        transaction.expense;
                              }
                            }
                            transList.remove(
                                transaction); // Removes selected transaction freom the list
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
