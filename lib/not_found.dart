import 'package:flutter/material.dart';

class NoTrans extends StatelessWidget {
  const NoTrans({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            // No Transaction Title
            'No Transactions added yet!',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w900,
            ),
          ),
          Padding(
            // No Transaction Image
            padding: const EdgeInsets.all(15.0),
            child: Image.asset(
              'assets/images/waiting.png',
              height: 150,
              width: 150,
              color: Colors.black.withOpacity(0.2),
            ),
          )
        ],
      ),
    );
  }
}
