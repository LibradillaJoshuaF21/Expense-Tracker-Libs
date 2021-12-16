import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final double totalExpense;
  final double expense;
  ProgressBar({
    Key? key,
    required this.totalExpense,
    required this.expense,
  }) : super(key: key);

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  var barHeight;

  @override
  Widget build(BuildContext context) {
    heightSetter(); // Calls the function to calculate barHeight, which determines the height of the colored bar
    return Container(
      child: SizedBox(
        child: Stack(
          // Stacks the two container bars
          children: [
            Container(
              // The bar behind the colored bar
              height: 50.0,
              width: 10.0,
              decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            Container(
              // The colored bar
              height: barHeight, // Height of the Colored Bar
              width: 10.0,
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ],
        ),
      ),
    );
  }

  void heightSetter() {
    // Calculates the width in relation to the width of the container bar
    if (widget.totalExpense == 0) {
      setState(() {
        barHeight = 0.0;
      });
    } else {
      setState(() {
        barHeight = ((widget.expense / widget.totalExpense) * 100) / 2;
      });
    }
  }
}
