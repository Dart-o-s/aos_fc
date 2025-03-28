/*
  some basic filesystem stuff, to be able to save on various platforms
 */

import 'dart:convert';
import 'dart:io';
import 'package:aos_fc/flash_card.dart';
import 'package:aos_fc/flash_card_extension.dart';

abstract class AbsFileSystem {
  String getBaseDirectory();
  // we can not make a default here, because of path separators

  AbsFileSystem(); // do nothing
  String getFullPath(String fileName);

  String getCWD() { return Directory.current.path; }
  Directory getCWDAsDir() { return Directory.current; }

  // https://www.geeksforgeeks.org/how-to-save-the-file-in-phone-storage-in-flutter/
  String save(String fileName, List<Flashcard>  store, void Function(String) done) {

    try {
      StringBuffer result = StringBuffer();
      for (var it in store) {
        result.writeln(it.question);
        result.writeln(it.answer);
      }
      var contents = result.toString();

      var fullPath = getFullPath(fileName);

      File out = File(fullPath);

      out.writeAsStringSync(contents, flush: true);
      return fullPath;

    } on Exception catch (_, e) {
      // message = _.toString() + " == \n" + e.toString();
      // print(message);
      return "<not saved>";
    } finally {
      // done(message);
    }
  }

  List<Flashcard> load(String fileName) {
    String fullName = getFullPath(fileName);

    List<Flashcard> store = <Flashcard>[];
    File inf = File(fullName);
/*
    var ex1 = File("/storage").existsSync();
    var ex2 = File("/storage/emulated").existsSync();
    var ex3 = File("/storage/emulated/0").existsSync();
    var ex4 = File("/storage/emulated/0/Download").existsSync();

    print("so far so good ...");
*/
    try {
      var text = inf.readAsLinesSync();

      for (int i = 0; (i + 1) < text.length; i += 2) {
        var front = text[i];
        var back = text[i + 1];
        store.add(Flashcard(question: front, answer: back));
      }
    } on Exception catch (x) {
      print("autsch!"+x.toString());
      // do nothing for now
      // we know store is empty, we handle it below
    }
    if (store.length == 0) {
      store.createInitialStack();
      store.fixMissingMetaCards();
    } else { // stack successfully loaded, but it might miss boxes or new chapters
      store.fixMissingMetaCards();
    }
    return store;
  }

    /*
      get all files from app's base directory
     */
  List<FileSystemEntity> getAllFiles(String suffix) {
    List<FileSystemEntity> res = [];
    var dir = Directory(getBaseDirectory());
    for (var entity in dir.listSync(recursive: false, followLinks: false)) {
      if (entity.path.endsWith(suffix) ||
          entity.path.endsWith('.txt') ||
          entity.path.endsWith('.text')) {
        res.add(entity);
        // print(entity.path);
      }
    }
    return res;
  }

  factory AbsFileSystem.forThisPlatform() {
    if (Platform.isAndroid) return AndroidFileSystem();
    if (Platform.isWindows) return WindowsFileSystem();
    return UseLessFileSystem(); // and crash
  }
}

// not sure if we should throw that, but during development this should never happen anyway
class UseLessFileSystem extends AbsFileSystem {
  @override
  String getBaseDirectory() {
    // TODO: implement getBaseDirectory
    throw UnimplementedError();
  }

  @override
  String getFullPath(String fileName) {
    // TODO: implement getFullPath
    throw UnimplementedError();
  }

  @override
  List<Flashcard> load(String fileName) {
    // TODO: implement load
    throw UnimplementedError();
  }
}

class AndroidFileSystem extends AbsFileSystem {
  // String getBaseDirectory() => "/data/data/priv.aos.storybook/"; // this worked, but the files where "invisible" for file explorers
  @override
  String getBaseDirectory() => "/storage/emulated/0/Download/";

  final String fileSuffix = ".flsh";

  @override
  String getFullPath(String fileName) {
    if (!fileName.contains(".")) fileName += ".flsh";
    return getBaseDirectory() + fileName;
  }
}

class WindowsFileSystem extends AbsFileSystem {
  final String documentDir = "C:\\Users\\angel\\Documents\\";
  final String fileSuffix = ".flsh";

  @override
  String getBaseDirectory() => documentDir;

  @override
  String getFullPath(String fileName) {
    if (!fileName.contains(".")) fileName += fileSuffix;
    if (!fileName.startsWith(documentDir)) return getBaseDirectory() + fileName;
    return fileName;
  }
}

extension on List<Flashcard> {
  void createInitialStack() {
    add(Flashcard(question: "Tab to flip Card. Do it now for short help.", answer: "Swipe left or right for next card. Up for not known. A card like '#1', creates a 'box', like '\$Title, creates a chapter"));
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
    if (findCardContaining("\$ Deleted") == -1)
      this.add(Flashcard(question: "\$ Deleted", answer: "This box contains deleted cards. For later retrievel or perma death."));
    // TODO more meta cards to follow -> "$ End-Marker"
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
    while (Flashcard.curIndexNum <= this.length-1) {
      var fc = this[Flashcard.curIndexNum];
      if (fc.question.startsWith("#") || fc.question.startsWith("\$"))
        return Flashcard.curIndexNum;

      ++Flashcard.curIndexNum;
    }
    return Flashcard.curIndexNum = this.length - 1;
  }

  void removeCurrent() {
    if (length == 1) return; // do not delete the last card
    var fc = this[Flashcard.curIndexNum];
    remove(fc);
    if (Flashcard.curIndexNum > length - 1) Flashcard.curIndexNum = length -1;
  }

  void deleteCurrentCard() {

  }
}
