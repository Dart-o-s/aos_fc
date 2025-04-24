import 'dart:io';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'home_widget.dart';
import 'AbsFileSystem.dart';
import 'flash_card.dart';
import 'global.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class AddFlashcardPage extends StatefulWidget {
  late bool edit;
  @override
  _AddFlashcardPageState createState() => _AddFlashcardPageState(edit);
  AddFlashcardPage({super.key, bool edit = false}) {
    this.edit = edit;
  }
}

final _from = TextEditingController(text:"en");
final _to   = TextEditingController(text:"th");

class _AddFlashcardPageState extends State<AddFlashcardPage> {
  final _questionController = TextEditingController();
  final _answerController   = TextEditingController();
  final bool edit;

  _AddFlashcardPageState(this.edit);

  // show a snack bar with a message
  void _snacker(String message) {
    final SnackBar snackBar = SnackBar(content: Text(message));
    snackbarKey.currentState?.showSnackBar(snackBar);
  }

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
        // TODO that would be behind the end marker and makes no real sense
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

    quickSave();
    _snacker("Card added");

    // Navigator.pop(context);

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
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: _addFlashcard, 
              child: edit ? Text("Edit Flashcard") : Text("Add Flashcard"),
            ),
            SizedBox(height: 25),
            Row(
              // not using this, as I try Spacers below
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("from: "),
                SizedBox(
                  width: 20,
                  child: TextField(controller: _from,)
                ),
                Spacer(),
                Text("to: "),
                SizedBox(
                  width: 20,
                  child: TextField(controller: _to,)
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: _fetchTranslation,
                  child: Text("Fetch Translation"),
                ),
              ],
            ),
            Spacer(),
            Text("Add as many cards as you want. Please use the back button when finished."),
          ],
        ),
      ),
    );
  }

  // https://stackoverflow.com/questions/19132441/google-translate-activity-not-working-anymore/20321335#20321335
  // https://pub.dev/documentation/intent_ns/latest/ (old)
  // https://pub.dev/packages/translator/example
  void _fetchTranslation() {
    if (kIsWeb) return;

    final translator = GoogleTranslator();
    // Using the Future API
    translator
        .translate(_questionController.text, from:_from.text, to:_to.text)
        .then((result) {
          _answerController.text = result.text;
          setState(() {
            // do nothing, just tell the UI to rebuild
          });
        }).catchError((onError) {
          _snacker(onError.toString());
    });
  }
}