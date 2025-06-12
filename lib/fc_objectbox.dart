// FlashCardFiles are objectbox entities that look and feel like ordinary text files
// only small difference is that we try to upgrade our model here a bit, while we
// introduce objectbox, and add a name and a description to the class
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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

class FlashCardBox {
  /// The Store of this app.
  late final Store _store;

  /// A Box of notes.
  late final Box<FlashCardFile> _fcBox;

  FlashCardBox._create(this._store) {
    _fcBox = Box<FlashCardFile>(_store);

    // Add some demo data if the box is empty.
    if (_fcBox.isEmpty()) {
      // copyAssets();
    }
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<FlashCardBox> create() async {
    // Note: setting a unique directory is recommended if running on desktop
    // platforms. If none is specified, the default directory is created in the
    // users documents directory, which will not be unique between apps.
    // On mobile this is typically fine, as each app has its own directory
    // structure.

    // Note: set macosApplicationGroup for sandboxed macOS applications, see the
    // info boxes at https://docs.objectbox.io/getting-started for details.

    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart

    String res = "";  // on my Android slate this is: /data/user/0/priv.aos.aos_fc/app_flutter/flashcard
    final store = await openStore(
        directory: res = p.join((await getApplicationDocumentsDirectory()).path, "flashcard"),
        macosApplicationGroup: "flashcard.demo");
    return FlashCardBox._create(store);
  }
}
