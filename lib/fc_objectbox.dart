// FlashCardFiles are objectbox entities that look and feel like ordinary text files
// only small difference is that we try to upgrade our model here a bit, while we
// introduce objectbox, and add a name and a description to the class
import 'package:objectbox/objectbox.dart';
import 'objectbox.g.dart'; // created by $ flutter pub run build_runner build, note: add this to pubspec.yaml - 'build_runner: ^2.4.9'
                           // or use: $ dart run build_runner build
@Entity()
class FlashCardFile {
  @Id()
  int id = -1;

  String name = "";        // serves as file name, or some descriptive name like "English - Japanese"
  String description = ""; // short description

  String fileData = "";    // lines of text, separated by new-line, one line source language next line target language

  FlashCardFile(this.id, this.name, this.description, this.fileData);

}