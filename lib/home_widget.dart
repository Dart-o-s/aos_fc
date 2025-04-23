
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

import 'dart:io';

import 'add_flashcard_page.dart';
import 'flash_card.dart';
import 'flash_card_widget.dart';
import 'AbsFileSystem.dart';
import 'global.dart';
import 'about_and_help_page.dart';
import 'import_page.dart';

import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart' show kIsWeb;

// import 'flash_card_extension.dart';
// https://pub.dev/packages/simple_gesture_detector/example

import 'package:device_info_plus/device_info_plus.dart';

// # fooling around
// # requires package
import 'package:external_path/external_path.dart';

// does not run on windows ... I had assumed it lists ~/Documents and ~/Downloads
// Get storage directory paths
Future<void> getPath_1() async {
  var path = await ExternalPath.getExternalStorageDirectories() as List<String>;
  print(path);  // [/storage/emulated/0, /storage/B3AE-4D28] - /storage/4F33-88C4]

  for (var it in path) {
    listDir(it);
  }
}

// To get public storage directory path
Future<void> getPath_2() async {
  var path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOAD);
  print(path);  // /storage/emulated/0/Download
  listDir(path);
}

//
void listDir(String base) {
  // on Android CWD is "/" - and that does not work
  var dir = Directory(base);
  for (var entity in dir.listSync(recursive: false, followLinks: false)) {
    print(entity.path);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool handlerIsUp = false;
  double _touchX = 0.0,
      _touchY = 0.0;
  bool _isMyTablet = false;

  _HomePageState() {
    figureModel();
  }

  @override
  Widget build(BuildContext context) {
    initCloseHandler(context);

    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
            centerTitle: false,
            title: Text("AoS FC", style: TextStyle(fontSize: 25)),
            backgroundColor: Colors.lightGreen[900],
            toolbarHeight: 40,
            elevation: 5,
            shadowColor: Colors.green[700],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            )
        ),
        floatingActionButton: _createFAB(context),
        body: Column(
            mainAxisAlignment: /* MainAxisAlignment.start */
            MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: GestureDetector(
                      onTapDown: _onTapTest,
                      //  <-- check simple GestureDetector
                      onLongPress: () {
                        _onLongPress(context);
                      },
                      onHorizontalDragEnd: _onSwipeLeftOrRight,
                      onVerticalDragEnd: _onSwipeUpOrDown,
                      /* old SimpleGD
                   onVerticalSwipe: _onSwipeUpOrDown,
                   onHorizontalSwipe: _onSwipeLeftOrRight,
                   swipeConfig: SimpleSwipeConfig(
                     verticalThreshold: 40.0,
                     horizontalThreshold: 40.0,
                     swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
                   ),
                    */
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: FlipCard(
                            direction: FlipDirection.HORIZONTAL,
                            front: FlashCardWidget(
                                side: CardSide.FRONT,
                                text: qaList[Flashcard.curIndexNum].question,
                                lightBC: _isMyTablet
                            ),
                            back: FlashCardWidget(
                                side: CardSide.BACK,
                                text: qaList[Flashcard.curIndexNum].answer,
                                lightBC: _isMyTablet)
                        ),
                      )))
            ]),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 5.0,
          clipBehavior: Clip.antiAlias,
          height: kBottomNavigationBarHeight / 2 + 8,
          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
          child: SizedBox(
            // TODO find a good size
            height: kBottomNavigationBarHeight * 0.75,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  tooltip: "prev Box/Chapter",
                  icon: const Icon(Icons.keyboard_double_arrow_left),
                  onPressed: () {
                    showPreviousBox();
                  },
                ),
                IconButton(
                  tooltip: "prev Card",
                  icon: const Icon(Icons.chevron_left_outlined),
                  onPressed: () {
                    showPreviousCard();
                  },
                ),
                /* IconButton(
                  tooltip: "New File",
                  icon: const Icon(Icons.file_copy_outlined),
                  onPressed: () {
                    setState(() {
                      // _newFile(context);
                    });
                  },
                ),*/
                buildQuickMenu(context),
                IconButton(
                  tooltip: "search ...",
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final _searchFieldController = TextEditingController();
                    var term = _showTextInputDialog(context, _searchFieldController).then(
                        (string) {
                          setState(() {
                            int idx = findCardContaining(_searchFieldController.text);
                            if (idx == -1) {
                              _snacker("not found!");
                              return;
                            }
                            Flashcard.curIndexNum = idx;
                          });
                        });
                  },
                ),
                IconButton(
                  tooltip: "next Card",
                  icon: const Icon(Icons.chevron_right_outlined),
                  onPressed: () {
                    setState(() {
                      showNextCard();
                    });
                  },
                ),
                IconButton(
                  tooltip: "next Box/Chapter",
                  icon: const Icon(Icons.keyboard_double_arrow_right),
                  onPressed: () {
                    setState(() {
                      showNextBox();
                    });
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> figureModel() async {
    if (kIsWeb) return;
    if (!Platform.isAndroid) return;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.model}');
    _isMyTablet = "Q101" == androidInfo.model;
  }

  Future<String?> _showTextInputDialog(BuildContext context, TextEditingController searchFieldController) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Search'),
            content: TextField(
              controller: searchFieldController,
              decoration: const InputDecoration(hintText: "。。。"), // タスクの名称を入力してください
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("キャンセル"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context, searchFieldController.text),
                // TODO Aos worst case we have to start the search here
              ),
            ],
          );
        });
  }
  PopupMenuButton<dynamic> buildQuickMenu(BuildContext context) {
    return PopupMenuButton(
      initialValue: 1,
      onSelected: (item) async {
        switch (item) {
        // that was tricky ... we have to smuggle a setState() behind the call ...
          case 1:
            _add();
          case 2:
            deleteCurrentCard();
            ;
          case 3:
            deleteCardForever();
            ;
          case 4:
            _loadFromWebStore();
          case 6:
            _moveToFront();
          case 7:
            _loadThaiFromAssets();
          case 8:
            _edit();
          case 'TEST': // easier to use Text if you want to randomly insert an new menu item
            _test();
        }
      },
      itemBuilder: (BuildContext context) =>
      <PopupMenuEntry>[
        const PopupMenuItem(value: 1, child: Text('add ...'), height: 24),
        const PopupMenuItem(value: 8, child: Text('edit ...'), height: 24),
        const PopupMenuItem(value: 2, child: Text('delete'), height: 24),
        const PopupMenuItem(value: 6, child: Text('un-delete'), height: 24),
        const PopupMenuItem(value: 3, child: Text('delete perma'), height: 24),

        if (kIsWeb)
          const PopupMenuItem(
              value: 4, child: Text('Load Web-Store'), height: 24),

        const PopupMenuItem(
            value: 5, child: Text('(new file ...)'), height: 24),
        const PopupMenuItem(
            value: 7, child: Text('Load From Assets ...'), height: 24),
        const PopupMenuItem(
            value: 'TEST', child: Text('_- TEST -_'), height: 24),

      ],
    );
  }

  void showNextCard() {
    setState(() {
      Flashcard.curIndexNum = (Flashcard.curIndexNum + 1 < qaList.length)
          ? Flashcard.curIndexNum + 1
          : 0;
    });
  }

  void showPreviousCard() {
    setState(() {
      Flashcard.curIndexNum = (Flashcard.curIndexNum - 1 >= 0)
          ? Flashcard.curIndexNum - 1
          : qaList.length - 1;
    });
  }

  void initCloseHandler(BuildContext context) {
    if (kIsWeb) return;
    if (!handlerIsUp && Platform.isWindows) {
      handlerIsUp = true;
      FlutterWindowClose.setWindowShouldCloseHandler(() async {
        return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: const Text('Do you really want to quit?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes')),
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No')),
                  ]);
            });
      });
    }
  }

  void showPreviousBox() {
    setState(() {
      qaList.findPreviousBox();
    });
  }

  void showNextBox() {
    setState(() {
      qaList.findNextBox();
    });
  }

  void deleteCurrentCard() {
    setState(() {
      qaList.deleteCurrentCard();
    });
  }

  void deleteCardForever() {
    setState(() {
      qaList.removeCurrent();
    });
  }

  /* secret tap corners --
  void _getTapPosition(TapDownDetails tapPosition) {
  setState(() {
    _tapPosition = tapPosition.globalPosition;
  });
  print(_tapPosition); // Debugging purposes
  }
   */
  void _onLongPress(BuildContext context) async {
    final RenderObject? overlay =
    Overlay
        .of(context)
        .context
        .findRenderObject();
    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromLTWH(_touchX, _touchY, 100, 100),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height),
        ),
        // position: RelativeRect.fromLTRB(10, 10, 40, 40),
        items: [
          const PopupMenuItem(value: "pushUp", child: Text('push to next box')),
          const PopupMenuItem(
              value: "import", child: Text('Import Copy/Paste ...')),
          const PopupMenuItem(value: "about", child: Text('About and Help')),
          const PopupMenuItem(
              value: "close", child: Text('(Blame Developer ...)')),
        ]);

    // setState(() { isPressed = false; }); // Handle menu item selection

    switch (result) {
      case 'pushUp':
        _pushToNextBox(context);
      case 'about':
        _aboutAndHelp(context);
      case 'import':
        _copyPasteImport(context);
        break;
    }
  }

  void _onSwipeUpOrDown(DragEndDetails direction) {
    double? where = direction.primaryVelocity ?? 0.0;
    if (direction.primaryVelocity != null) {
      if ((where < 0.0))
        _didKnow();

      if (where > 0.0)
        _didNotKnow();
    }
  }

  void _onSwipeLeftOrRight(DragEndDetails direction) {
    double? where = direction.primaryVelocity ?? 0.0;
    if (direction.primaryVelocity != null) {
      if (where < 0.0) showNextCard();
      if (where > 0.0) showPreviousCard();
    }
  }

  void _onTapTest(TapDownDetails details) {
    _touchX = details.globalPosition.dx;
    _touchY = details.globalPosition.dy;
    print(" Touch on: $_touchX, $_touchY");
  }

  void _didKnow() {
    showNextCard();
    setState(() {
      _snacker(" you knew it !");
    });
  }

  void _didNotKnow() {
    qaList.moveCurrentToFront();
    setState(() {
      final SnackBar snackBar = SnackBar(
          content: Text(" card moved to front "));
      snackbarKey.currentState?.showSnackBar(snackBar);
    });
  }

  void _moveToFront() {
    _didNotKnow();
  }

  Future<String> loadAsset({String name = 'assets/data/aos-thai.flsh'}) async {
    return await rootBundle.loadString(name);
  }

  // just a helper method to be called from UI for quick tests
  void _test() {
    // getPath_1();
    // getPath_2();
  }

  void _loadThaiFromAssets() async {
    if (await
    confirm(context,
        title: Text("loading from Assets",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
            "This will replace your current Box of Cards. Do you want to continue?",
            style: TextStyle(fontSize: 24)))
    ) {
      var file = loadAsset();

      file.then((value) {
        appendTextToQAList(value);
      }).catchError((error) => print(error));

      setState(() {
        _snacker("Thai loaded from Assets.");
      });
    }
  }

  void _edit() async {
    final value = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFlashcardPage(edit: true)),
    );
    setState(() {
      final SnackBar snackBar = SnackBar(content: Text(" edited "));
      snackbarKey.currentState?.showSnackBar(snackBar);
    });
  }

  _createFAB(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () => _didKnow(),
          heroTag: 'new it!',
          mini: true,
          child: const Icon(Icons.thumb_up_alt_outlined),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: () => _didNotKnow(),
          heroTag: 'did not know',
          // foregroundColor: Theme.of(context).colorScheme.onSecondary,
          mini: true,
          child: const Icon(Icons.thumb_down),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: () => _add(),
          heroTag: 'new Card',
          // foregroundColor: Theme.of(context).colorScheme.onSecondary,
          mini: true,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }

  void _add() async {
    final value = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFlashcardPage()),
    );
    setState(() {});
  }

  void _loadFromWebStore() {
    var fs = AbsFileSystem.forThisPlatform();
    qaList = fs.load("aos-thai");
    setState(() {
      _snacker("loaded from browser web store");
    });
  }

  // show a snack bar with a message
  void _snacker(String message) {
    final SnackBar snackBar = SnackBar(content: Text(message));
    snackbarKey.currentState?.showSnackBar(snackBar);
  }

  void _copyPasteImport(BuildContext context) async {
    final value = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ImportPage(title: "Edit or Copy/Paste below")),
    );
    setState(() {});
  }

  void _aboutAndHelp(BuildContext context) async {
    final value = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutAndHelpPage(title: "About & Help")),
    );
    setState(() {});
  }

  void _pushToNextBox(BuildContext context) {
    var rem = Flashcard.curIndexNum;
    var fc = Flashcard.getCurrent();

    // findNext() uses Flashcard.curIndexNum, stupid idea
    var where = findNextBox();
    var box = qaList[where];

    if (where == 0) return;

    qaList.remove(fc);
    qaList.insert(where, fc);

    Flashcard.curIndexNum = where;

    setState(() {
      _snacker(" ${fc.question} moved behind ${box.question}");
    });

  }
}

extension on List<Flashcard> {
  void createInitialStack() {
    add(Flashcard(
        question: "Tab to flip Card. Do it now for short help.",
        answer:
            "Swipe left or right for next card. Up for not known. A card like '#1', creates a 'box', like '\$Title, creates a chapter"));
  }

  // for now this is a simple "contains test"
  // we check both back and front
  // TODO consider to switch to regexp
  // TODO make individual searches possible
  int findCardContaining(String pattern) {
    for (int res = 0; res < this.length; res++) {
      final fc = this[res];
      if (fc.question.contains(pattern)) return res;
      if (fc.answer.contains(pattern)) return res;
    }
    return -1;
  }

  void fixMissingMetaCards() {
    if (findCardContaining("\$ Deleted") == -1) addDeletedMarker();
    // TODO more meta cards to follow -> "$ End of File Marker"
  }

  // we know there is no delete marker
  void addDeletedMarker() {
    var del = Flashcard(
        question: "\$ Deleted",
        answer:
            "This box contains deleted cards. For later retrieval or perma death.");
    var idx = findCardContaining("\$ End of File Marker");
    if (idx == -1) { // no end of file marker, just add the delete marker
      add(del);
    } else {
      insert(idx, del);
    }
  }

  int findPreviousBox() {
    // worst edge case: we are *at the beginning already* then we just jump to the first card
    if (Flashcard.curIndexNum == 0) {
      Flashcard.curIndexNum = length - 1;
      return Flashcard.curIndexNum;
    }
    // not at begin, we can decrease by one (in case we are on a "Chapter" we do not want to stick here)
    Flashcard.curIndexNum--;
    while (Flashcard.curIndexNum >= 0) {
      var fc = this[Flashcard.curIndexNum];
      if (fc.question.startsWith("#") || fc.question.startsWith("\$"))
        return Flashcard.curIndexNum;

      --Flashcard.curIndexNum;
    }
    return Flashcard.curIndexNum = 0;
  }

  int findNextBox() {
    // worst edge case: we are *at the end already* then we just jump to the first card
    if (Flashcard.curIndexNum == length - 1) {
      Flashcard.curIndexNum = 0;
      return Flashcard.curIndexNum;
    }
    // not at end, we can increase by one (in case we are on a "Chapter" we do not want to stick here)
    ++Flashcard.curIndexNum;
    while (Flashcard.curIndexNum <= this.length - 1) {
      var fc = this[Flashcard.curIndexNum];
      if (fc.question.startsWith("#") || fc.question.startsWith("\$"))
        return Flashcard.curIndexNum;

      ++Flashcard.curIndexNum;
    }
    return Flashcard.curIndexNum = this.length - 1;
  }

  // remove permanently
  // TODO check if it is behind "$ Deleted"
  void removeCurrent() {
    if (length == 1) return; // do not delete the last card
    var fc = this[Flashcard.curIndexNum];
    remove(fc);
    if (Flashcard.curIndexNum > length - 1) Flashcard.curIndexNum = length - 1;
    quickSave();
  }

  // move the current card behind the "$ Deleted" marker card
  void deleteCurrentCard() {
    var del = findCardContaining("\$ Delete");
    var fc = this[Flashcard.curIndexNum];
    if (del == -1) {
      remove(fc);
      addDeletedMarker();
      add(fc);
    } else {
      remove(fc);
      insert(del, fc); // del is the old position of the del marker
    }
    quickSave();
  }

  void moveCurrentToFront() {
    var fc = this[Flashcard.curIndexNum];
    remove(fc); // loser did not know this
    insert(1,fc); // move to front, behind first card
    print (" moved card to front");
    quickSave();
  }
}

void quickSave() {
  AbsFileSystem fs = AbsFileSystem.forThisPlatform();
  fs.save("aos-thai", qaList, (String doNothing) {});
}