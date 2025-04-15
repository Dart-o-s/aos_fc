import 'dart:io';

import 'package:flutter/material.dart';
import 'AbsFileSystem.dart';
import 'flash_card.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

/*
import 'package:intent_ns/intent.dart' as fcIntent;
import 'package:intent_ns/extra.dart';
import 'package:intent_ns/typedExtra.dart';
import 'package:intent_ns/action.dart' as fcAction;
*/

class AddFlashcardPage extends StatefulWidget {
  late bool edit;
  @override
  _AddFlashcardPageState createState() => _AddFlashcardPageState(edit);
  AddFlashcardPage({super.key, bool edit = false}) {
    this.edit = edit;
  }
}

class _AddFlashcardPageState extends State<AddFlashcardPage> {
  final _questionController = TextEditingController();
  final _answerController   = TextEditingController();
  final bool edit;

  _AddFlashcardPageState(this.edit);

  void _addFlashcard() {
    if (edit) {
      var fc = qaList.elementAt(Flashcard.curIndexNum);
      fc.question = _questionController.text;
      fc.answer = _answerController.text;
    } else if (_questionController.text.isNotEmpty && _answerController.text.isNotEmpty) {
      setState(() {
        int pos = Flashcard.curIndexNum + 1; // add behind current
        var flashcard = Flashcard(
          question: _questionController.text,
          answer: _answerController.text,
        );
        if (pos == qaList.length) {
          qaList.add(flashcard);
          Flashcard.curIndexNum = qaList.length - 1;
        } else {
          qaList.insert(pos, flashcard);
          Flashcard.curIndexNum++;
        }
      });
    }

    _questionController.clear();
    _answerController.clear();

    AbsFileSystem fs = AbsFileSystem.forThisPlatform();
    fs.save("aos-thai", qaList, (String doNothing) { } );

    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    if (edit) {
      var fc = Flashcard.getCurrent();
      _questionController.text = fc.question;
      _answerController.text = fc.answer;
    }
    return Scaffold(
      appBar: AppBar(
        title: edit ? Text ("Edit the Question or Answer") : Text("Enter the Question and Answer of your choice"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Enter Question',
              ),
            ),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                labelText: 'Enter Answer',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addFlashcard, 
              child: edit ? Text("Edit Flashcard") : Text("Add Flashcard"),
            ),
            /*
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchTranslation,
              child: Text("Fetch Translation"),
            ),
            */
          ],
        ),
      ),
    );
  }

  // https://stackoverflow.com/questions/19132441/google-translate-activity-not-working-anymore/20321335#20321335
  // https://pub.dev/documentation/intent_ns/latest/
  void _fetchTranslation() {
    if (kIsWeb) return;
    if (!Platform.isAndroid)
      return;
/*
    var intent = fcIntent.Intent()
      ..setAction(fcAction.Action.ACTION_TRANSLATE)
      ..putExtra(Extra.EXTRA_TEXT, "I Love Computers")
      ..startActivity().catchError((e) => print(e));
  */
  }
}