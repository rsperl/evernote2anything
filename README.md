# Usage

```perl
use Evernote::EnexParser;

my $enex_file = "EvernoteExport.enex";
my $parser = Evernote::EnexParser->new(xmlfile => $enex_file);
my @notes = $parser->notes;
foreach my $note ( @notes ) {
    printf "Title: %s\n", $note->title;
    printf "Tags:  %s\n", join(", ", @{$note->tags} );
    printf "RawBody: %s\n", $note->raw_body;
}
```

Parsing the body is the tricky part. Evernote has special tags for pictures, videos, etc. This at least gives you a easier access to the different parts of the note. The next step is to do some decent parsing on the body.

# Starter Script #

I've included a starter script ```en2something.pl``` to get you started. Use it by calling it as 

```
en2something.pl path/to/exportedNotes.enex
```
It will parse the notes and print out the title of each note. You can extend this by parsing the body and writing to file or however you want to process the note.

# Next #

I'll continue to work on parsing the body with markdown being the preferred output format.

