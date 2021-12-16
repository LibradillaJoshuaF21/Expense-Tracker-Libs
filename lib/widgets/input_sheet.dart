import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_expense_tracker/models/transaction_model.dart';

class InputSheet extends StatefulWidget {
  InputSheet({Key? key}) : super(key: key);

  @override
  _InputSheetState createState() => _InputSheetState();
}

class _InputSheetState extends State<InputSheet> {
  DateTime selectedDate = DateTime.now(); // Gets the current date
  bool hasSelected =
      false; // Variable to determine if user has selected a date in date picker
  TransModel transaction = TransModel(
      expense: 0,
      title: 'title',
      transDate: null,
      isAdded: false); // Prepares the container for storing transaction data
  TextEditingController transTitle =
      TextEditingController(); // Form Controller for inputted transaction title
  TextEditingController transExpense =
      TextEditingController(); // Form Controller for inputted transaction expense

  @override
  Widget build(BuildContext context) {
    return Container(
      // Input Content which inlcludes Title Input, Amount Input, Date Picker, Add Button
      height: MediaQuery.of(context).size.height * 0.45,
      child: Material(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  // The Input Title Field
                  controller: transTitle,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Title',
                  ),
                ),
                TextFormField(
                  // The Input Amount Field
                  controller: transExpense,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Amount',
                  ),
                  keyboardType: TextInputType.number, // Input only numbers
                  inputFormatters: <TextInputFormatter>[
                    // Filters inputs that are not numbers
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                Padding(
                  // Date Input Row
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // Displays No Date or Selected Date
                        hasSelected
                            ? 'Picked Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}' // Selected Date
                            : 'No Date Chosen', // No Date
                      ),
                      TextButton(
                        // Button to boot Date Picker
                        onPressed: () {
                          _selectDate(
                              context); // Function to activate Date Picker and pick date
                        },
                        child: Text('Choose Date'),
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                  // Add Transaction Button
                  onPressed: () {
                    if (transExpense.text.isNotEmpty &&
                        transTitle.text.isNotEmpty &&
                        hasSelected) {
                      // Adds transaction if input fields are not empty, creates a transaction with data from form controllers
                      transaction.expense = double.parse(transExpense.text);
                      transaction.title = transTitle.text;
                      transaction.transDate = selectedDate;
                      Navigator.pop(context,
                          transaction); // Closes Sliding Sheet and returns the transaction input to result
                    }
                  },
                  child: SizedBox(
                    height: 25,
                    width: 100,
                    child: Center(
                      child: Text(
                        'Add Transaction',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    // Generates the Date Picker widget
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate:
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day - 6),
      lastDate: selectedDate,
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        hasSelected =
            true; // Sets hasSelected to true if user has selected a date
        selectedDate = selected; // Stores selected date to selectedDate
      });
  }
}
