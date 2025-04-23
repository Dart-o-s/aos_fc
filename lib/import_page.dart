import 'package:aos_fc/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';
import 'flash_card.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key, required this.title});

  final String title;

  @override
  State<ImportPage> createState() => _ImportPage();
}

class _ImportPage extends State<ImportPage> {
  @override
  Widget build(BuildContext context) {
    late CodeLineEditingController lec;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(children: <Widget>[
        Expanded(child: CodeEditor(
          // todo Aos text size
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
        ElevatedButton(onPressed: () {
          appendTextToQAList(lec.text, insert: true);
          quickSave();
        }, child: Text("import"))
      ]),
    );
  }
}
