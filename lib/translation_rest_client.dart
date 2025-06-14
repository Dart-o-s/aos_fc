/*
  Helper class to perform REST calls to a server, retrieving JSON
  https://github.com/LibreTranslate/LibreTranslate?tab=readme-ov-file
 */

import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'translate_line_by_line.dart';

var url = Uri.http('localhost:5000', '/translate');
var inputfile = "C:\\Users\\angel\\AndroidStudioProjects\\FlashCards-Learning-App-in-Flutter\\data\\800words.txt";
var outputfile = "C:\\Users\\angel\\AndroidStudioProjects\\FlashCards-Learning-App-in-Flutter\\data\\800words-en-it.flsh";

// for now the Translation processor uses the globals here
class TranslationProcessor implements LineProcessor {
  final String fileName;
  late File out;
  late IOSink output;
  late http.Client client;

  TranslationProcessor(this.fileName) {
    out = File(fileName);
    output = out.openWrite(mode:FileMode.write);
    client = http.Client();
  }

  @override
  String process(String line) {
    String res = "";
    translate(line)
        .then((val) {
          output.writeln(line);
          output.writeln(val);
          res = val;
        });

    //print("Done: ${line}");
    return res;
  }

  finish() {
    output.close();
    client.close();
  }

  Future<String> translate (String line) async {
      var rQBody =
      """
{"q":"${line}","source":"en","target":"it","format":"text","alternatives":3}
""";
      var headers = <String,String>{"Content-Type" : "application/json"};

      // Await the http get response, then decode the json-formatted response.
      var response = await client.post(url, headers: headers, body: rQBody);

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(convert.utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        var alternatives = jsonResponse['alternatives'];
        // print('Alternatives: ${alternatives.length}.');

        String alt = "";
        for (var x in alternatives)
          alt += alt.length == 0 ? "$x" : "; $x";

        var translation = jsonResponse['translatedText'];
        if (translation != null && ("" != alt))
          translation = translation + " or: " + alt;

        // print('TranslatedText: $translation.');
        return translation;

      } else {
        print('Request failed with status: ${response.statusCode}.');
        return line + " - ${response.statusCode}";
      }
    }
  }


void main(List<String> arguments) async {
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview
  final now = DateTime.now();
  print("Start: $now");
  LineReader reader = LineReader(inputfile);
  reader.process(TranslationProcessor(outputfile))
    .then((value) {
    final end = DateTime.now();
    print("\n\nEnd: $end");
  });

  return;
}