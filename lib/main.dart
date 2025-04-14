import '../home_widget.dart';
import 'package:flutter/material.dart';

import 'package:aos_fc/AbsFileSystem.dart';
import 'package:aos_fc/flash_card.dart';

import 'global.dart';

void main() {
  AbsFileSystem fs = AbsFileSystem.forThisPlatform();
  qaList = fs.load("aos-thai");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: snackbarKey, // <= this
        debugShowCheckedModeBanner: false,
        title: "Aos' Flashcard App",
        home: HomePage());
  }
}