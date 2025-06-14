/*
  some basic filesystem stuff, to be able to save on various platforms
 */

import 'dart:convert';
import 'dart:io';
import 'package:aos_fc/flash_card.dart';
import 'package:aos_fc/flash_card_extension.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

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

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/data/800words-th.flsh');
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
          entity.path.endsWith('.flsh') ||
          entity.path.endsWith('.text')) {
        res.add(entity);
        // print(entity.path);
      }
    }
    return res;
  }

  factory AbsFileSystem.forThisPlatform() {
    if (kIsWeb) return WebFileSystem();
    if (Platform.isAndroid) return AndroidFileSystem();
    if (Platform.isWindows) return WindowsFileSystem();
    return UseLessFileSystem(); // and crash
  }

  List<Flashcard> initialStore(String s) {
    // TODO this is for web only ...
    // but save to call in any circumstances
    var res = <Flashcard>[];
    var fc = Flashcard(
        question: "Select from the dot menu below, to load your words",
        answer: "on web, the previous file can not be simply loaded");

    res.add(fc);

    return res;
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

/// flutter run -d chrome --web-port 8877
/// keep same port, to keep the data
class WebFileSystem extends AbsFileSystem {
  bool localStorageIsInitialized=false;

  WebFileSystem()  {
    WidgetsFlutterBinding.ensureInitialized();
    initStorage();
  }

  @override
  String getBaseDirectory() {
    return "";
  }

  @override
  String getFullPath(String fileName) {
    if (!fileName.contains(".")) fileName += ".flsh";
    return fileName;
  }

  @override
  List<FileSystemEntity> getAllFiles(String suffix) {
    return [];
  }

  @override
  String getCWD() {
    return "";
  }

  @override
  Directory getCWDAsDir() {
    return Directory("");
  }

  @override
  List<Flashcard> load(String fileName) {
    List<Flashcard> res = [];

    String data = localStorage.getItem(fileName) ?? "";
    if (data == "") {
      res.createInitialStack();
      res.fixMissingMetaCards();
    } // AOS TODO split data up
    return res;
  }

  @override
  String save(String fileName, List<Flashcard> store, void Function(String p1) done) {

    /*if (!localStorageIsInitialized) {
      print("error: LS not initialized");
      return "error: LS not initialized";
    }
    */

    StringBuffer result = StringBuffer();
    for (var it in store) {
      result.writeln(it.question);
      result.writeln(it.answer);
    }

    var contents = result.toString();
    localStorage.setItem(fileName, contents);

    // see: https://stackoverflow.com/questions/13292744/why-isnt-localstorage-persisting-in-chrome
    // retrieve it, as some Browsers do not persist keys that did not get used
    load(fileName);

    return fileName;
  }

  void initStorage() async {
    await initLocalStorage();
    localStorageIsInitialized=true;
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

int findNextBox() {
  return qaList.findNextBox();
}

int findCardContaining(String it) {
  int cur = Flashcard.curIndexNum;
  int found = qaList.findCardContaining(it, from: cur);

  if (found != -1) return found;

  return qaList.findCardContaining(it);
}
