import '../home_widget.dart';
import 'package:flutter/material.dart';

import 'package:aos_fc/AbsFileSystem.dart';
import 'package:aos_fc/flash_card.dart';

import 'global.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  // AOS TODO if it is web, don't load the file during startup ...
  AbsFileSystem fs = AbsFileSystem.forThisPlatform();
  if (kIsWeb)
    qaList = fs.initialStore("aos-thai");
  else
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