# moving to object box
    I wanted to write down what I did and what failed or worked as the C++ project does not build for me (does not build the objectbox.dll, something about my lack of understanding of how MS Studio is building)
    The Dart example from github does not build either.

    However integrating opbect box into this "toy project" worked flawlessly!

## protocol about what I am doing

    [x] DONE 2025-06-12 19:49 new Entity in fc_objectbox.dart
    [x] DONE 2025-06-12 19:52 added build runner to pubspec.yaml 
    [x] DONE 2025-06-12 19:53 waiting in main() for flutter to initialize

### Status
     'dart run build_runner build' does not report any errors, but:
        - objectbox.g.dart is not generated
        - the json model file is not generated

    initializing the Box (only one entity) is fine
    simple queries on a non ID attribute work fine

## Added to pubspec.yaml
    [x]  DONE 2025-06-12 20:07   
        - objectbox_generator: any

    [!] SUCESS 2025-06-12 20:12 dart run build_runner build
        - generated objectbox.g.dart
        - generated objectbox-model.json

    [x] DONE 2025-06-12 21:00 just in case - do not know yet if I need it
        - objectbox_flutter_libs: any
        + was needed, it loads the relevant dll under windows

## End DONE 2025-06-14 19:50
    - Regarding object Box integration, it sdeems done!
    - Runs on windows just fine. 
    - Android up to testing, but I do not expect problems.