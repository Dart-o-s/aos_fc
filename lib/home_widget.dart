import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

import 'dart:io';

import 'add_flashcard_page.dart';
import '../flash_card.dart';
import 'flash_card_widget.dart';
import 'package:aos_fc/AbsFileSystem.dart';

// https://pub.dev/packages/simple_gesture_detector/example

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool handlerIsUp = false;

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
                borderRadius: BorderRadius.circular(10))
        ),

        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox (
                  // padding: EdgeInsets.only(top:15),
                  // width: 300,
                  height: 565,
                  child: FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      front: FlashCardWidget(
                          side: CardSide.FRONT,
                          text: qaList[Flashcard.curIndexNum].question),
                      back: FlashCardWidget(
                          side: CardSide.BACK,
                          text: qaList[Flashcard.curIndexNum].answer))),
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
                  // this button is there only during development
                  // to run some "testing code" quickly.
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
                    setState(() {
                      // search(context);
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
        )
    );
  }

  PopupMenuButton<dynamic> buildQuickMenu(BuildContext context) {
    return PopupMenuButton(
                initialValue: 1,
                onSelected: (item) async  {
                  // that was tricky ... we have to smuggle a setState() behind the call ...
                  switch (item) {
                    case 1:
                    final value = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddFlashcardPage()),
                    );
                    setState(() {
                    });
                    case 2:
                      ;
                    case 3:
                      ;
                    case 4:
                      ;
                  }
                },
                itemBuilder:
                    (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(value: 1, child: Text('add ...'), height: 24),
                  const PopupMenuItem(value: 2, child: Text('(delete)'), height: 24),
                  const PopupMenuItem(value: 3, child: Text('(edit)'), height: 24),
                  const PopupMenuItem(value: 4, child: Text('(new file ...)'), height: 24),
                ],
              );
  }

  void showNextCard() {
    setState(() {
      Flashcard.curIndexNum = (Flashcard.curIndexNum + 1 < qaList.length) ? Flashcard.curIndexNum + 1 : 0;
    });
  }

  void showPreviousCard() {
    setState(() {
      Flashcard.curIndexNum =
          (Flashcard.curIndexNum - 1 >= 0) ? Flashcard.curIndexNum - 1 : qaList.length - 1;
    });
  }

  void initCloseHandler(BuildContext context) {
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
    setState( () {
      qaList.findPreviousBox();
    });
  }

  void showNextBox() {
    setState( () {
      qaList.findNextBox();
    });
  }
}

extension on List<Flashcard> {
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
    while (Flashcard.curIndexNum <= this.length-1) {
      var fc = this[Flashcard.curIndexNum];
      if (fc.question.startsWith("#") || fc.question.startsWith("\$"))
        return Flashcard.curIndexNum;

      ++Flashcard.curIndexNum;
    }
    return Flashcard.curIndexNum = this.length - 1;
  }
}

// Padding(//   THIS IS THE CODE TO HAVE THE QUESTION ANSWER TEXTFIELD ON SAME PAGE
//   padding: const EdgeInsets.all(8.0),
//   child:Column(
//     children: [
//       TextField(
//         controller: _questionController,
//         decoration: InputDecoration(
//           labelText: 'Enter Question',
//         ),
//       ),
//       TextField(
//         controller: _answerController,
//         decoration: InputDecoration(
//           labelText: 'Enter Answer',
//         ),
//       ),
//       SizedBox(height: 10),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green[700],
//             shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(5)),
//           ),
//           onPressed: _addFlashcard,
//           child: Text("Add Flashcard",
//                     style: TextStyle(fontSize: 10, letterSpacing: 1.0,fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.center,
//                       ),
//         ),

//   ],
//   )

// )
