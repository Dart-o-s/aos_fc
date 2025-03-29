/*
  Helper class to perform REST calls to a server, retrieving JSON
  https://github.com/LibreTranslate/LibreTranslate?tab=readme-ov-file
 */

import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

void main(List<String> arguments) async {
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview
  var url =
  Uri.http('localhost:5000', '/translate');

  var body = """
{"q":"spicey","source":"en","target":"th","format":"text","alternatives":3}
  """;
  var headers = <String,String>{"Content-Type" : "application/json"};

  // Await the http get response, then decode the json-formatted response.
  var response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var itemCount = jsonResponse['alternatives'];
    print('Alternatives: $itemCount.');

    var translation = jsonResponse['translatedText'];
    print('TranslatedText: $translation.');

  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}