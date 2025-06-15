import 'dart:typed_data';

/*
    // see: https://stackoverflow.com/questions/51613234/convert-a-string-of-uint8list-to-a-unit8list
    final utf8Encoder = utf8.encoder;
    var uint8Data = utf8Encoder.convert(FlashCardBox.current.fileData);
 */

// the below is not working correctly!

StringBuffer uint8_2_str(Uint8List bytes) {
  // Bytes to UTF-16 string
  StringBuffer buffer = new StringBuffer();
  for (int i = 0; i < bytes.length;) {
    int firstWord = (bytes[i] << 8) + bytes[i + 1];
    if (0xD800 <= firstWord && firstWord <= 0xDBFF) {
      int secondWord = (bytes[i + 2] << 8) + bytes[i + 3];
      buffer.writeCharCode(((firstWord - 0xD800) << 10) + (secondWord - 0xDC00) + 0x10000);
      i += 4;
    }
    else {
      buffer.writeCharCode(firstWord);
      i += 2;
    }
  }
  return buffer;
}

Uint8List str_2_uint8(String source) {
  var list = <int>[];
  source.runes.forEach((rune) {
    if (rune >= 0x10000) {
      rune -= 0x10000;
      int firstWord = (rune >> 10) + 0xD800;
      list.add(firstWord >> 8);
      list.add(firstWord & 0xFF);
      int secondWord = (rune & 0x3FF) + 0xDC00;
      list.add(secondWord >> 8);
      list.add(secondWord & 0xFF);
    }
    else {
      list.add(rune >> 8);
      list.add(rune & 0xFF);
    }
  });
  Uint8List bytes = Uint8List.fromList(list);
  return bytes;
}