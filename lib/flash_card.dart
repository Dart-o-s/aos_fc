import 'dart:math';
import 'AbsFileSystem.dart';

var random = Random();

void appendTextToQAList(String value, {bool insert = false}) {

  int at = insert ? 1 : findCardContaining("\$ Deleted") - 1;

  List<String> lines = value.split("\n");
  for (int i = 0; (i + 1) < lines.length; i += 2) {
    var front = lines[i];
    var back = lines[i + 1];
    qaList.insert(at, Flashcard(question: front, answer: back));
  }
}

class Flashcard {
  // TODO sorry, refactoring relict. Was in home_widget
  // TODO we need a "storage" instead of the global qaList
  static int curIndexNum = 0;

  String question;
  String answer;

  Flashcard({required this.question, required this.answer});

  static Flashcard getCurrent() => qaList.elementAt(Flashcard.curIndexNum);

  bool get isSpecial { return question.startsWith("#") || question.startsWith("\$"); }
}

Flashcard pickRandom() {
   int idx = random.nextInt(qaList.length);
   var fc = qaList[idx];
   int tries = 10; // perhaps some smart user removed all cards except the "boxes" ... sigh
   while (fc.isSpecial && tries-- > 0) {
     idx = random.nextInt(qaList.length);
     fc = qaList[idx];
   }
   Flashcard.curIndexNum = idx;
   return fc;
}

List<Flashcard> qaList = [
  Flashcard(
      question: "What is the building block of a Flutter app?",
      answer: "Widget"),
  Flashcard(
      question: "What is State in Flutter?",
      answer: "State refers to the data or information that can change dynamically during the lifetime of a widget."),
  Flashcard(
      question: "What is the purpose of the Widget Inspector in Flutter?",
      answer: "It is a tool used to inspect and debug the widget tree of a Flutter app"),
  Flashcard(
      question:
          "What is a Stream in Flutter?",
      answer:
          "Stream is a sequence of asynchronous events that can be listened to and responded to."),
  Flashcard(
      question:
          "Is Flutter Open Source or not?",
      answer: "Yes"),
];