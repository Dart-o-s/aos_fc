
class Flashcard {
  // TODO sorry, refactoring relict. Was in home_widget
  // TODO we need a "storage" instead of the global qaList
  static int curIndexNum = 0;

  final String question;
  final String answer;

  Flashcard({required this.question, required this.answer});
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