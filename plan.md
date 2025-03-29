# we have a plan

## high prio items
    [X] DONE 2025-03-28 15:07 LOGO!
    [✔] DONE 2025-03-29 18:17 do the learning thing
    [✔] DONE 2025-03-29 18:18 add swipes later

    [ ] OPEN if Stack is empty, the first cards get added behind "$ Deleted", that is odd!!
    [ ] OPEN known cards are not moved to higher boxes yet

    [ ] Memory like game based on this cards
        - place a set of cards double with opposing sides 

## probably usable in Storybook
https://github.com/ChristopherA/iambic-mnemonic/blob/master/word-lists/README.md
https://medium.com/flutter-community/flutter-flip-card-animation-eb25c403f371
https://stackoverflow.com/questions/43928702/how-to-change-the-application-launcher-icon-on-flutter
https://pub.dev/packages/graphviz/versions/0.0.10

## Interesting:
https://pub.dev/documentation/gesture_x_detector/latest/

## normal backlog
    [ ] Floating notification icon (up and down).
    [ ] OPEN make a simple text field as for pasting in text and use it as import screen
    [ ] OPEN import the basic english word list
        - use the categories as starting blocks for new Ontologies
        - make other simple lsits (German etc.)
    [w] OPEN add boxes for short and long term memory
        - delete moves behind "$ Deleted"
        - DONE 2025-03-28 02:12 << previous chapter - or beginning if there is none
        - DONE 2025-03-28 02:12 >> next chapter - or end if there is none
        OPEN _undelete_ move current card to position 1
        OPEN perma delete by removing from the list


    [1] OPEN make a small frame around flip pane
        [✓] Tablet
        [✓] Windows
        [✅] Phone ✅ ✔ ✓ 🗹
        [1] change colour on Tablet - probably based on device name?
    [ ] OPEN put on "New Flash Card" a google translate widget

## after first release
    [ ] OPEN figure how the files view on the tablet worjs, as orgro uses it as "save" dialog!
    [ ] OPEN share button via mail
    [ ] OPEN import
        - without merge
        - with merge
    [ ] mini MD parser - for settings
        # header
        [] checkbox
        - ignore rest

    [_] OPEN script to copy/merge the windows data file into Assets of the project. So it is in Git.
        - and can be distributed together with the App
        - the App should unpack the Asset to ~/Download

    [X] DONE 2025-03-28 15:26 after refactoring, creating a new Card does not directly move to it
        HINT: use await for Navigator.push() and put a setState() behind it.
        - for that comming back to the previous screen needs to make it repaint
            that is tricky and out of scope for today/tonight: just move to the next manually
        Look: https://stackoverflow.com/questions/49804891/force-flutter-navigator-to-reload-state-when-popping 
            at: accepted answer

    [x] DONE 2025-03-28 00:42 add chapters - which are behind the boxes?
        [x] DONE 2025-03-28 00:42 Special Chapter "$ Deleted" for deleted Cards

    [x] DONE 2025-03-28 00:42 change the add option to "insert" at current position
    
    [ ] OPEN when inserting treat "# box" and "* chapter" special
        - I think for now, "# Chapters" could be just placed before "$ Deleted"
        - "$ Chapters" just where the user puts them

    [] make sure added cards contain no \n or \r
        perhaps in load and store, just replace?

    [x] DONE 2025-03-27 22:08 add arrows to browse from box to box 
    [] OPEN add menu? "longpress?" for "ok" "not ok", "delete" and "edit"

    [x] DONE 2025-03-27 15:54 change size of window on Windows
        DONE 2025-03-27 22:08 change width of center widget, see below

    [X] DONE 2025-03-29 00:41 figure why on Android the Flip Cart is to far on top
        - we figured if "width: property" is ommited, it resiszes horizontally quite nicely
            but the same does not work for "height:"
        = used an Expandable instead of a SizeBox. On the tablet perhaps to big.
    
    [ ] OPEN change the background colour on the eInk tablet

## unplanned items 
    - stuff we made without thinking
    - but want to keep track off, as it was a "distraction"