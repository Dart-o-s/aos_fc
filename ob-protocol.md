# moving to object box

## protocol about what I am doing

    [x] DONE 2025-06-12 19:49 new Entity in fc_objectbox.dart
    [x] DONE 2025-06-12 19:52 added build runner to pubspec.yaml 
    [x] DONE 2025-06-12 19:53 waiting in main() for flutter to initialize

### Status
     'dart run build_runner build' does not report any errors, but:
        - objectbox.g.dart is not generated
        - the json model file is not generated

## Added to pubspec.yaml
    [x]  DONE 2025-06-12 20:07   
        - objectbox_generator: any

    [!] SUCESS 2025-06-12 20:12 dart run build_runner build
        - generated objectbox.g.dart
        - generated objectbox-model.json

    [x] DONE 2025-06-12 21:00 just in case - do not know yet if I need it
        - objectbox_flutter_libs: any
        + was needed, it loads the relevant dll under windows