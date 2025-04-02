/*
Read from a file line by line, and process each line, with a processor.
 */

import 'dart:io';

// just work on one line at a time,
// what it returns and how it is used
// is up to the user/implementor
abstract class LineProcessor {
  String process (String line);
  void finish();
}

class LineReader {
  String fileName;
  // LineProcessor proc;
  late File toRead;

  LineReader(this.fileName) {
    toRead = File(fileName);
  }

  // pipe each line into processor to
  Future<int> process(LineProcessor it) async {
    int res = 0;

    List<String> lines = await toRead.readAsLines();
    for (var line in lines ) {
      res++;
      it.process(line);
    }
    // it.finish(); // wrong place, it closes the sink before the read is finished ...
    return res;
  }
}

