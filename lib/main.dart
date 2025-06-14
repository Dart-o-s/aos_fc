import '../home_widget.dart';
import 'package:flutter/material.dart';

import 'package:aos_fc/AbsFileSystem.dart';
import 'package:aos_fc/flash_card.dart';

import 'global.dart';
import 'fc_objectbox.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart'   show rootBundle;

final gMain = FlashCardApp();
late final AbsFileSystem fs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  fs = AbsFileSystem.forThisPlatform();
  if (kIsWeb) {
    qaList = fs.initialStore("aos-thai");
    runApp(gMain);
  } else {
    await FlashCardBox.create()
    .then( (value) {
      objectbox = value;
      FlashCardFile? fcf = objectbox.find("800words-en-th.flsh");

      if (fcf != null)
        qaList = fcf.makeQAList();

      runApp(gMain);

    })
    .catchError((e) {
      // ignore the error.
      print (e); /// should not happen
    });
  }
}

class FlashCardApp extends StatelessWidget {
  @override
  late String _itsAboutText;
  bool aboutLoaded = false;

  Widget build(BuildContext context) {
    // AOS move into the menu handler, load on demand
    if (!aboutLoaded) {
      rootBundle.loadString("assets/data/about_and_help.md")
        .then((s) {
          _itsAboutText = s;
          aboutLoaded = true; })
        .catchError((err) {});
    }

    return MaterialApp(
        scaffoldMessengerKey: snackbarKey, // <= this is needed for reuse in the _snacker-Method
        debugShowCheckedModeBanner: false,
        title: "Aos' Flashcard App",
        home: HomePage());
  }

  FlashCardApp() {
  }

  int get currentCardNum => Flashcard.curIndexNum;
  int get numCards => qaList.length;

  String get aboutText => _itsAboutText.replaceFirst("{p1}", "${currentCardNum}/${numCards-1}");
}