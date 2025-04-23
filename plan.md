# we have a plan

## high prio items
    [ ] BUG Some methods got moved into AbsFileSystem, but they belong to "the App"
        [?] I think I duplicated it to there, because the import did not work

    [X] DONE 2025-04-23 18:15 test if I can copy my assests into downloads (Android)
            and modify them with an editor.
        Drawback: my Orgro saves with struggles ... and messes up data.

    [X] OPEN confirmation dialog, before we overwrite the Downloads

    [X] DONE 2025-04-23 18:54 try to load from Downloads first, then load assets
        - that was the default
        - at the moment replacing the "installed" app via debugger keeps it able to 
            manipulate its file on ~/Downloads

    [X] DONE 2025-04-23 22:22 about page with build date and number of cards 
    [X] DONE 2025-04-23 22:24 help text, included in About Page 

    [ ] BUG OPEN if there is no "$ Deleted " marker, inserting one and deleting the card mix their positions
    [ ] BUG OPEN left and right swipe swipe wrong.

    [ ] OPEN search ...
    [ ] OPEN "import a file" via copy paste, append it to the stack

    [ ] OPEN known cards are not moved to higher boxes yet

    [ ] OPEN import a file via copy/paste. Append or overwrite.
    [ ] OPEN About dialog with build date and time

### delayed

    [ ] Clean up script for plan.md, move all DONE items to the end
    [ ] OPEN ask for FileSystem permissions
        [ ] OPEN select files from filesystem

    [O] OPEN PWA / Web Storage
        does not work on Windows - stuff in the browser vanishes
        the "desktop installed app" does not launch
        [ ] OPEN lets try on Android as web page served from my laptop
        [ ] OPEN if web-storage does not work, lets try indexDB

    [X] DONE 2025-04-14 17:27 "move to front" menu item
        Solved: use "thumb down" for that

    [ ] OPEN Flavicon for Windows
    [X] DONE 2025-03-28 15:07 LOGO!
    [✔] DONE 2025-03-29 18:17 do the learning thing
    [✔] DONE 2025-03-29 18:18 add swipes later

    [X] DONE 2025-04-14 17:28 if Stack is empty, the first cards get added behind "$ Deleted", that is odd!!
        Not that odd: the bug happened when the "second last card" was selected/shown

    [ ] Memory like game based on this cards
        - place a set of cards double with opposing sides

    [X] Figure how to load/write from assets
        load is done, write is not possible, it seems

    [ ] OPEN figure if you can write into your privte store and read from it

## probably usable in Storybook
https://github.com/ChristopherA/iambic-mnemonic/blob/master/word-lists/README.md
https://medium.com/flutter-community/flutter-flip-card-animation-eb25c403f371
https://stackoverflow.com/questions/43928702/how-to-change-the-application-launcher-icon-on-flutter
https://pub.dev/packages/graphviz/versions/0.0.10

## Interesting:
https://pub.dev/documentation/gesture_x_detector/latest/

## normal backlog
    [ ] OPEN intent_ns: ^2.0.0 fix it on github, after upgrading to high level Kotlin, it does not compiler\

    [X] DONE 2025-04-14 17:44 find "com.example.sample" and replace it with "priv.aos.aos_fc"
    [ ] Check for scrollable Bottom Action Bar
        - Is a custom bar, probably not worth it ATM for this app 

    [ ] Floating notification icon (up and down)
    [ ] OPEN make a simple text field as for pasting in text and use it as import screen
    [ ] OPEN import the basic english word list
        - use the categories as starting blocks for new Ontologies
        - make other simple lists (German etc.)
        - upgrade the translator to do that - have the words marked ($, #)

    [X] DONE 2025-04-14 17:47 add boxes for short and long term memory
        - delete moves behind "$ Deleted"
        - DONE 2025-03-28 02:12 << previous chapter - or beginning if there is none
        - DONE 2025-03-28 02:12 >> next chapter - or end if there is none
        - DONE 2025-04-14 17:45 _undelete_ move current card to position 1
        - DONE 2025-04-14 17:46 perma delete by removing from the list

    [1] OPEN make a small frame around flip pane
        [✓] Tablet
        [✓] Windows
        [✅] Phone ✅ ✔ ✓ 🗹
        [1] change colour on Tablet - probably based on device name?

    [ ] OPEN put on "New Flash Card" a google translate widget

## after first release
    [ ] OPEN figure how the files view on the tablet works, as orgro uses it as "save" dialog!
    [ ] OPEN share button via mail
    [ ] OPEN import
        - without merge
        - with merge
    [ ] mini MD parser - for settings / resp. use "Properties class" 
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
    
    [X] DONE 2025-04-14 17:26 when inserting treat "# box" and "* chapter" special
        - I think for now, "# Chapters" could be just placed before "$ Deleted"
        - "$ Chapters" just where the user puts them
        Solved: we just put them where the user is browsing

    [] OPEN make sure added cards contain no \n or \r
        perhaps in load and store, just replace?

    [x] DONE 2025-03-27 22:08 add arrows to browse from box to box 
    [o] OPEN add menu? "longpress?" for "ok" "not ok", "delete" and
        ok/not ok is not good for longpress, duration is to long
    [ ] OPEN "edit" is in the bottom menu

    [x] DONE 2025-03-27 15:54 change size of window on Windows
        DONE 2025-03-27 22:08 change width of center widget, see below

    [X] DONE 2025-03-29 00:41 figure why on Android the Flip Cart is to far on top
        - we figured if "width: property" is ommited, it resiszes horizontally quite nicely
            but the same does not work for "height:"
        = used an Expandable instead of a SizeBox. On the tablet perhaps to big.
    
    [X] DONE 2025-04-14 14:14 / long ago ... change the background colour on the eInk tablet
    
    [X] DONE 2025-04-14 17:18 set up a "snackbar" for short messages
        - ugly and floats to long, I think ...

    [ ] OPEN Search in Appbar
        https://pub.dev/packages/app_bar_with_search_switch

    [-] OPEN Copy to clipboard button as tap is used for flip
        [ ] delayed - we can go to "edit", copy there and abort
    
## knowledge
https://walnutistanbul.medium.com/creating-a-scrollable-bottom-navigation-bar-in-flutter-f11845cfa3d5

## unplanned items 
    - stuff we made without thinking
    - but want to keep track off, as it was a "distraction"