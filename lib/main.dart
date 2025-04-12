import 'dart:io';
import 'package:external_path/external_path.dart';

import '../home_widget.dart';
import 'package:flutter/material.dart';

import 'package:aos_fc/AbsFileSystem.dart';
import 'package:aos_fc/flash_card.dart';


void main() {
  AbsFileSystem fs = AbsFileSystem.forThisPlatform();
  qaList = fs.load("aos-thai");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getPath_1();
    getPath_2();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Aos' Flashcard App",
        home: HomePage());
  }
}


// # fooling around

// # requires package

// does not run on windows ... I had assumed it lists ~/Documents and ~/Downloads
// Get storage directory paths
Future<void> getPath_1() async {
  var path = await ExternalPath.getExternalStorageDirectories();
  print(path);  // [/storage/emulated/0, /storage/B3AE-4D28]

  // please note: B3AE-4D28 is external storage (SD card) folder name it can be any.
}

// To get public storage directory path
Future<void> getPath_2() async {
  var path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOAD);
  print(path);  // /storage/emulated/0/Download
}

//
void listDir(String base) {
  // on Android CWD is "/" - and that does not work
  var dir = Directory(base);
  for (var entity in dir.listSync(recursive: false, followLinks: false)) {
    print(entity.path);
  }
}
