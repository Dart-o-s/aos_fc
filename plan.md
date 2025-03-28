# we have a plan

## high prio items
    [X] DONE 2025-03-28 15:07 LOGO!

## probably usable in Storybook

https://medium.com/flutter-community/flutter-flip-card-animation-eb25c403f371
https://stackoverflow.com/questions/43928702/how-to-change-the-application-launcher-icon-on-flutter

## normal backlog
    [] OPEN add boxes for short and long term memory
        - delete moves behind "$ Deleted"
        - DONE 2025-03-28 02:12 << previous chapter - or beginning if there is none
        - DONE 2025-03-28 02:12 >> next chapter - or end if there is none

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
        - means, put "$ Chapters" automatically at the end.
        - I think for now, "# Chapters" could be just placed before "$ Deleted"

    [] make sure added cards contain no \n or \r
        perhaps in load and store, just replace?

    [x] DONE 2025-03-27 22:08 add arrows to browse from box to box 
    [] OPEN add menu? "longpress?" for "ok" "not ok", "delete" and "edit"

    [x] DONE 2025-03-27 15:54 change size of window on Windows
        DONE 2025-03-27 22:08 change width of center widget, see below

    [w] OPEN figure why on Android the Flip Cart is to far on top
        - we figured if "width: property" is ommited, it resiszes horizontally quite nicely
            but the same does not work for "height:"

## unplanned items 
    - stuff we made without thinking
    - but want to keep track off, as it was a "distraction"