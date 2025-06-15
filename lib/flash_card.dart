import 'dart:math';
import 'AbsFileSystem.dart';
import 'fc_objectbox.dart';

var _random = Random();
typedef FlashCards = List<Flashcard>;

FlashCards gQAList = [
  Flashcard(
      question: "If you see this, tap the three dot icon in the app bar",
      answer: "load a deck from the three dot icon menu")
];

void appendTextToQAList(String value, {bool insert = false}) {

  int at = insert ? 1 : findCardContaining("\$ Deleted") - 1;

  List<String> lines = value.split("\n");
  for (int i = 0; (i + 1) < lines.length; i += 2) {
    var front = lines[i];

    if (front.startsWith("#") || front.startsWith("\$"))
      continue; // skip special cards

    var back = lines[i + 1];
    gQAList.insert(at++, Flashcard(question: front, answer: back));
  }
}

class Flashcard {
  // TODO sorry, refactoring relict. Was in home_widget
  // TODO we need a "storage" instead of the global qaList
  // AoS since we moved to objectbox, we have to marry
  // this old stuff into the new FlashCardFile - and then burn everything, haha
  static int curIndexNum = 0;

  String question;
  String answer;

  Flashcard({required this.question, required this.answer});

  static Flashcard getCurrent() => gQAList.elementAt(Flashcard.curIndexNum);

  bool get isSpecial { return question.startsWith("#") || question.startsWith("\$"); }
}

StringBuffer asStringBuffer(FlashCards store) {
  StringBuffer result = StringBuffer();
  for (var it in store) {
    result.writeln(it.question);
    result.writeln(it.answer);
  }
  return result;
}

Flashcard pickRandom() {
   int idx = _random.nextInt(gQAList.length);
   var fc = gQAList[idx];
   int tries = 10; // perhaps some smart user removed all cards except the "boxes" ... sigh
   while (fc.isSpecial && tries-- > 0) {
     idx = _random.nextInt(gQAList.length);
     fc = gQAList[idx];
   }
   Flashcard.curIndexNum = idx;
   return fc;
}

List<String> listAllBoxes() {
  var res = <String>[];
  gQAList.forEach((fc) {
    if (fc.question.startsWith("#") || fc.question.startsWith("\$"))
      res.add(fc.question);
  });
  return res;
}

extension FCExtras on List<Flashcard> {
  void createInitialStack() {
    add(Flashcard(question: "Tab to flip Card. Do it now for short help.", answer: "Swipe left or right for next card. Up for not known. A card like '#1', creates a 'box', like '\$Title, creates a chapter"));
  }

  // for now this is a simple "contains test"
  // we check both back and front
  // TODO consider to switch to regexp
  // TODO make individual searches possible
  int findCardContaining(String pattern, {int from = 0}) {
    for (int res = from; res < this.length; res++) {
      final fc = this[res];
      if (fc.question.contains(pattern)) return res;
      if (fc.answer.contains(pattern)) return res;
    }
    return -1;
  }

  // TODO move all "fix Stack" methods into this class
  void fixMissingMetaCards() {
    // if no "$ End of File Marker", we add that first
    var eof = findCardContaining("\$ End of File Marker");

    if (eof == -1) {
      add(Flashcard(
          question: "\$ End of File Marker",
          answer: "Just a Marker, so moving from box to box is more easy "));
      eof = length - 1;
    }

    if (findCardContaining("\$ Deleted") == -1) {
      var dell = Flashcard(
          question: "\$ Deleted",
          answer: "This box contains deleted cards. For later retrieve or perma death.");
      insert(eof, dell);
      eof = length - 1; // in case we add more markers, keep EoF updated
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

  /***
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
   ********/

  /***
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
   ******/
  //// TODO
  /// TODO how did this end up in AbsFileSystem?
  // TODO
  // TODO Aos don't destroy the index!!
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

  /*
  // remove permanently
  // TODO check if it is behind "$ Deleted"
  void removeCurrent() {
    if (length == 1) return; // do not delete the last card
    var fc = this[Flashcard.curIndexNum];
    remove(fc);
    if (Flashcard.curIndexNum > length - 1) Flashcard.curIndexNum = length - 1;
    objectbox.quickSave();
  }
  */

  // move the current card behind the "$ Deleted" marker card
  void deleteCurrentCard() {
    var del = findCardContaining("\$ Delete");
    var fc = this[Flashcard.curIndexNum];
    if (del == -1) {
      remove(fc);
      // addDeletedMarker();
      add(fc);
    } else {
      remove(fc);
      insert(del, fc); // del is the old position of the del marker
    }
    gFlashCardBox.quickSave();
  }

  void removeCurrent() {
    if (length == 1) return; // do not delete the last card
    var fc = this[Flashcard.curIndexNum];
    remove(fc); // Aos use removeAt
    if (Flashcard.curIndexNum > length - 1) Flashcard.curIndexNum = length -1;
    gFlashCardBox.quickSave();
  }

  int findExact(String question) {
    for (int i = 0; i < gQAList.length; i++) {
      if (gQAList[i].question == question) {
        return i;
      }
    }
    return -1;
  }
}
