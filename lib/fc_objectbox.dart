// FlashCardFiles are objectbox entities that look and feel like ordinary text files
// only small difference is that we try to upgrade our model here a bit, while we
// introduce objectbox, and add a name and a description to the class
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show AssetManifest, rootBundle;

import 'flash_card.dart';

import 'package:objectbox/objectbox.dart';
import 'objectbox.g.dart'; // created by $ flutter pub run build_runner build, note: add this to pubspec.yaml - 'build_runner: ^2.4.9'
                           // or use: $ dart run build_runner build

// initialized in main() - AoS check if it can be initialized here
late FlashCardBox objectbox;

@Entity()
class FlashCardFile {
  @Id()
  int id = 0;

  String name = "";        // serves as file name, or some descriptive name like "English - Japanese"
  String description = ""; // short description

  String fileData = "";    // lines of text, separated by new-line, one line source language, next line target language

  FlashCardFile(this.id, this.name, this.description, this.fileData);

  // create a list of questions and answers
  List<Flashcard> makeQAList() {
    List<Flashcard> store = <Flashcard>[];
    var text = fileData.split("\n");

    for (int i = 0; (i + 1) < text.length; i += 2) {
      var front = text[i];
      var back = text[i + 1];
      store.add(Flashcard(question: front, answer: back));
    }
    return store;
  }
}

/**
 * Holds FlashCardFiles
 */
class FlashCardBox {
  /// The Store of this app
  late final Store _store;

  /// A Box of FlashCardFile's
  late final Box<FlashCardFile> _fcBox;

  static FlashCardFile? _current = null;
  bool _catalogLoaded = false;

  static FlashCardFile get current => _current ?? FlashCardFile(0, "empty", "nothing inside", "");

  FlashCardBox._create(this._store) {
    _fcBox = Box<FlashCardFile>(_store);

    // copy the flash card decks from assets to the box
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
      final catalogText = assetManifest.listAssets().where(
              (string) => string.startsWith("assets/data/") && string.endsWith(".flsh")
        ).toList();

      _catalogLoaded = true;

      for (var name in catalogText) {
        var fileData = await rootBundle.loadString(name);
        var deckName = name.split("/").last;

        if (!inBox(name)) {
          FlashCardFile fcf = createFlashCardFileWithMetaCards(deckName, fileData);
          var id = _fcBox.put(fcf);
        } else {
          print ("$name already boxed!");
        }
      }

      /* example
      Query<User> query = userBox.query(User_.firstName.equals('Joe')).build();
      List<User> joes = query.find();
      query.close();
       */

      /*
      final query = _fcBox.query().build();
      List<String> names = query.property(FlashCardFile_.name).find();
      query.close();

      print (names);
      */

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

  FlashCardFile createFlashCardFileWithMetaCards(String name, String fileData) {
    String header = """
Welcome to ${name}. Tap to flip the card.
A card like "#1 'some text'" creates a box. A card like "\$ 'Chapter Name'" is a chapter.     
""";

    String footer = """
\$ Deleted
This box contains deleted cards. Undelete them, or delete them permanently from here.    
\$ End of File Marker
Just a marker for moving between boxes more easy.    
""";
    var end = "\n";
    if (fileData.endsWith("\n"))
      end = "";

    return FlashCardFile(
            0, name, "$name, loaded from assets", header + fileData + end + footer);
  }

  /**
   * check if a certain named FlashCardFile exists
   */
  bool inBox(String name) {
    final qBuilder = _fcBox.query(FlashCardFile_.name.equals(name));
    final query = qBuilder.build();
    // return all entities matching the query
    List<FlashCardFile> fcfs = query.find();
    return fcfs.isNotEmpty;
  }

  /**
   * some query examples:
      final qBuilder = _fcBox.query(FlashCardFile_.name.endsWith(name));

      // return all entities matching the query
      List<FlashCardFile> joes = query.find();

      // return only the first result or null if none
      FlashCardFile joe = query.findFirst();

      // return the only result or null if none, throw if more than one result
      FlashCardFile joe = query.findUnique();
   */
  FlashCardFile? find(String name) {
    final query = _fcBox.query(FlashCardFile_.name.endsWith(name)).build();
    // return all entities matching the query
    List<FlashCardFile> fcfs = query.find();
    if (fcfs.isNotEmpty) return fcfs[0];
    else null;
  }

  List<String> listFiles() {
    final query = _fcBox.query().build();
    List<String> names = query.property(FlashCardFile_.name).find();
    query.close();
    return names;
  }
}
