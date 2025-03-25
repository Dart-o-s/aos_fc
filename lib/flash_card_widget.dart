
import 'package:flutter/material.dart';

class FlashCardWidget extends StatelessWidget {
  FlashCardWidget({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        elevation: 17,
        shadowColor: Color.fromARGB(255, 2, 75, 6),
        color: Colors.green[700],
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child:
                Text(text, style: TextStyle(fontSize: 30, letterSpacing: 1.0,fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}