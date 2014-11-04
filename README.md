# introduction

I use evernote a lot, but I would like to know I could move to something else if I wanted.
This script will convert an exported evernote note(s) to a more generic format.

I found TagSpaces which uses the name of the file for the name of the note, and saves the tags inside the name of the file like

```name of file[tag1 tag2 tag3].md```

The output of the notes will be markdown and named using this format.

# usage

Import file.enex and save the exported notes to the current directory.
```en2md.pl --import file.enex --output-dir .```

# current status
It's way early. It handles basic text and html-formatted text, but does not handle attachments of any kind, including images. That's next -- I may need to use both the enex and html export to correctly capture it. Any input is welcome.
