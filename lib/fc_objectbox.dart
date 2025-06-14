// FlashCardFiles are objectbox entities that look and feel like ordinary text files
// only small difference is that we try to upgrade our model here a bit, while we
// introduce objectbox, and add a name and a description to the class
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show AssetManifest, rootBundle;

import 'package:objectbox/objectbox.dart';
import 'objectbox.g.dart'; // created by $ flutter pub run build_runner build, note: add this to pubspec.yaml - 'build_runner: ^2.4.9'
                           // or use: $ dart run build_runner build
@Entity()
class FlashCardFile {
  @Id()
  int id = 0;

  String name = "";        // serves as file name, or some descriptive name like "English - Japanese"
  String description = ""; // short description

  String fileData = "";    // lines of text, separated by new-line, one line source language, next line target language

  FlashCardFile(this.id, this.name, this.description, this.fileData);
}

/**
 * Holds FlashCardFiles
 */
class FlashCardBox {
  /// The Store of this app
  late final Store _store;

  /// A Box of FlashCardFile's
  late final Box<FlashCardFile> _fcBox;

  bool _catalogLoaded = false;
  List<String> _catalogText = [];

  FlashCardBox._create(this._store) {
    _fcBox = Box<FlashCardFile>(_store);

    // copy the flash card desk from assets to the box
    if (_fcBox.isEmpty()) {
      copyAssets();
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

  /**
   * How to load asset names
   * see: https://stackoverflow.com/questions/56544200/flutter-how-to-get-a-list-of-names-of-all-images-in-assets-directory
   * A3tera's answer
   */
  void copyAssets() async {
    if (!_catalogLoaded) {
      final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      _catalogText = assetManifest.listAssets().where(
              (string) => string.startsWith("assets/data/") && string.endsWith(".flsh")
        ).toList();

      _catalogLoaded = true;

      /*
      rootBundle.loadString("assets/data/about_and_help.md")
          .then((s) {
          })
          .catchError((err) {
            print ("could not load catalog from assets");
      });
       */
    }
  }
}
