import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'main.dart';

class AboutAndHelpPage extends StatefulWidget {
  const AboutAndHelpPage({super.key, required this.title});

  final String title;
  @override
  State<AboutAndHelpPage> createState() => _AboutAndHelpPage();
}

class _AboutAndHelpPage extends State<AboutAndHelpPage> {
  @override
  Widget build(BuildContext context) {
    var markdown = gMain.aboutText;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Markdown(
            selectable: true,
            data: markdown,
            styleSheet: MarkdownStyleSheet(
              h1: const TextStyle(fontSize: 24, color: Colors.blue),
              code: const TextStyle(fontSize: 14, color: Colors.green),// new end
            ),
          ),
        ));
  }
}