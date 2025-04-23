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

    var markdownO = """
Here's a simple Go program that prints "Hello, world!" to the console😀:

```go
package main
import "fmt"

func main() {
    fmt.Println("Hello, world!")
}
```

Save the above code in a file with a `.go` extension, for example `hello.go`. Then, you can run the program by executing the following command in your terminal:

```shell
go run hello.go
```

The output will be:

```
Hello, world!
```
*Bold End*?
""";
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