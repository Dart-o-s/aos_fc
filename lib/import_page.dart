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
            ElevatedButton(
              onPressed: () {
                _loadFile();
              },
              child: Text("import file ...")
            ),
            ElevatedButton(
              onPressed: () {
                appendTextToQAList(lec.text, insert: true);
                gFlashCardBox.quickSave();
              },
              child: Text("add to Deck")
            ),
            // TODO AoS: option to remove duplicates in the editor first
            ElevatedButton(
                onPressed: () {
                  _mergeTextIntoQAList(lec.text, insert: true);
                  gFlashCardBox.quickSave();
                },
                child: Text("merge into")
            ),
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
        if (lec.text.isEmpty) // put into Edit Controller
          lec.text = text.join("\n");
        else // append to the controller, make sure to have an \n as separator
          lec.text += end + text.join("\n");
      } on Exception catch (x) {
        print("autsch! "+x.toString());
        // do nothing for now
    }
    } else {
      // User canceled the picker
    }
  }

  // we only insert cards, where the front side does not exist in the store
  // Aos TODO: we do not merge same front sides, if the back sides are different
  void _mergeTextIntoQAList(String text, {required bool insert}) {
    int at = 1;
    List<String> lines = text.split("\n");
    for (int i = 0; (i + 1) < lines.length; i += 2) {
      var front = lines[i];

      if (front.startsWith("#") || front.startsWith("\$"))
        continue; // skip special cards

      var pos = gQAList.findCardWithFront(front);
      if (pos == -1) {
        var back = lines[i + 1];
        gQAList.insert(at++, Flashcard(question: front, answer: back));
      }
    }

  }
}
