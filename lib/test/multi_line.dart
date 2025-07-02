var it = "test";

// testing if variables get expanded in a multi line string ... because I did that in "Some language"
// a while ago, and forgot if it works in Dart or not.
var x = """
Does it expand?
${it}
""";

var y = """ <<< $x (is here a #lf before 'Does'? >>> """;

main () {
  print(y);
}

// a) no extra linefeed
// b) yes string interpolation works in multi line strings