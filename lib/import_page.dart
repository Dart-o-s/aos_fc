import 'dart:io';

import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';
import 'package:file_picker/file_picker.dart';

import 'fc_objectbox.dart';
import 'flash_card.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key, required this.title});

  final String title;

  @override
  State<ImportPage> createState() => _ImportPage();
}

class _ImportPage extends State<ImportPage> {
  late CodeLineEditingController lec;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(children: <Widget>[
        Expanded(child: CodeEditor(
          // todo Aos text size
          style: CodeEditorStyle(fontSize: 24),
          indicatorBuilder:
              (context, editingController, chunkController, notifier) {
            lec = editingController;
            return Row(
              children: [
                DefaultCodeLineNumber(
                  controller: editingController,
                  notifier: notifier,
                ),
                DefaultCodeChunkIndicator(
                    width: 20, controller: chunkController, notifier: notifier)
              ],
            );
          },
        )),
        Row(
          children: [
            ElevatedButton(onPressed: () {
              _loadFile();
            }, child: Text("import file ...")),
            ElevatedButton(onPressed: () {
              appendTextToQAList(lec.text, insert: true);
              objectbox.quickSave();
            }, child: Text("add to Deck"))
          ]
        )
      ]),
    );
  }

  Future<void> _loadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      try {
        File file = File(result.files.single.path!);
        var text = file.readAsLinesSync();
        var end = lec.text.endsWith("\n") ? "" : "\n";
        if (lec.text.isEmpty)
          lec.text = text.join("\n");
        else
          lec.text += end + text.join("\n");
      } on Exception catch (x) {
        print("autsch!"+x.toString());
        // do nothing for now
    }
    } else {
      // User canceled the picker
    }
  }
}
