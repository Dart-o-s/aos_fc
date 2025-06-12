import '../home_widget.dart';
import 'package:flutter/material.dart';

import 'package:aos_fc/AbsFileSystem.dart';
import 'package:aos_fc/flash_card.dart';

import 'global.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;

var gMain = MyApp();

void main() {
  // AOS TODO if it is web, don't load the file during startup ...
  WidgetsFlutterBinding.ensureInitialized();

  AbsFileSystem fs = AbsFileSystem.forThisPlatform();
  if (kIsWeb)
    qaList = fs.initialStore("aos-thai");
  else
    qaList = fs.load("aos-thai");
  runApp(gMain);
}

class MyApp extends StatelessWidget {
  @override
  late String _itsAboutText;
  bool aboutLoaded = false;

  Widget build(BuildContext context) {
    if (!aboutLoaded) {
      rootBundle.loadString("assets/data/about_and_help.md")
        .then((s) {
          _itsAboutText = s;
          aboutLoaded = true; })
        .catchError((err) {});
    }

    return MaterialApp(
        scaffoldMessengerKey: snackbarKey, // <= this
        debugShowCheckedModeBanner: false,
        title: "Aos' Flashcard App",
        home: HomePage());
  }

  MyApp() {
  }

  int get currentCardNum => Flashcard.curIndexNum;
  int get numCards => qaList.length;

  String get aboutText => _itsAboutText.replaceFirst("{p1}", "${currentCardNum}/${numCards-1}");
}