import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

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
    gQAList = fs.initialStore("aos-thai");
    runApp(gMain);
  } else {
    await FlashCardBox.create()
    .then( (value) {
      gFlashCardBox = value;
      FlashCardFile? fcf = gFlashCardBox.findAndSetCurrent("800words-en-th.flsh");

      if (fcf != null)
        gQAList = fcf.makeQAList();

      runApp(gMain);

    })
    .catchError((e) {
      // ignore the error.
      print (e); /// should not happen
    });
  }
}

class FlashCardApp extends StatefulWidget {
  @override
  State<FlashCardApp> createState() => _FlashCardAppState();

  FlashCardApp() {
  }

  String get aboutText =>  "TODO: Something wring here. By Aos Enkimaru -aka- Angelo Schneider. Error: About Text not loaded.";

}

class _FlashCardAppState extends State<FlashCardApp> {
  @override
  late String _itsAboutText;

  bool aboutLoaded = false;

  late StreamSubscription _intentSub;
  String _sharedText = "";

  // String get aboutText => _itsAboutText != null ? _itsAboutText : "by Aos Enkimaru -aka- Angelo Schneider. Error: About Text not loaded.";

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

  int get currentCardNum => Flashcard.curIndexNum;

  int get numCards => gQAList.length;

  String get aboutText => _itsAboutText.replaceFirst("{p1}", "${currentCardNum}/${numCards-1}");

  @override
  void initState() {
    super.initState();
  // 1. For when the app is already alive in memory
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((List<SharedMediaFile> value) {
      _processSharedFiles(value);
    }, onError: (err) {
      debugPrint("getMediaStream error: $err");
    });

    // 2. For when the app is totally closed and launched via share intent
    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      _processSharedFiles(value);

      // Explicitly tell the library processing is complete
      // Gemini wants me to remove it. ReceiveSharingIntent.instance.reset();
    });
  }

  void _processSharedFiles(List<SharedMediaFile> files) {
    if (files.isEmpty) return;

    // Filter list to grab text type elements exclusively
    for (var file in files) {
      if (file.type == SharedMediaType.text ||
          file.type == SharedMediaType.url) {
        setState(() {
          // The actual plain text string is stored inside the 'path' property
          _sharedText = file.path;
        });
        debugPrint("Received shared text/url successfully: $_sharedText");
        _snacker(_sharedText);
        break; // Stop after capturing the first text entry if required
      }
    }
  }

  @override
  void dispose() {
    _intentSub.cancel(); // Prevent memory leaks
    super.dispose();
  }

  // show a snack bar with a message
  void _snacker(String message) {
    final SnackBar snackBar = SnackBar(content: Text(message));
    snackbarKey.currentState?.showSnackBar(snackBar);
  }

}