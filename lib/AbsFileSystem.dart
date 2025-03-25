/*
  some basic filesystem stuff, to be able to save on various platforms
 */

import 'dart:convert';
import 'dart:io';
import 'package:aos_fc/flash_card.dart';

abstract class AbsFileSystem {
  String getBaseDirectory();
  // we can not make a default here, because of path separators

  AbsFileSystem(); // do nothing
  String getFullPath(String fileName);

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

    File inf = File(fullName);
    var text = inf.readAsLinesSync();

    List<Flashcard> store = <Flashcard>[];
    for (int i = 0; (i+1) < text.length; i+=2) {
      var front = text[i];
      var back = text[i+1];
      store.add(Flashcard(question:front, answer:back));
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

  // Store load(String fileName);
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
