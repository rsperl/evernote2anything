## Requirements

Perl dependencies:

* DateTime
* Moose
* HTML::WikiConverter
* HTML::WikiConverter::Markdown
* Template::Toolkit

These can be installed by running

```
sudo perl -MCPAN -e "install DateTime Moose HTML::WikiConverter HTML::WikiConverter::Markdown"
```

Please note that because of a [bug](https://rt.cpan.org/Public/Bug/Display.html?id=53531) in HTML::WikiConverter,
you'll need to follow the instructions at the link to make it work correctly.


## Usage

```
use Evernote::EnexParser;
use Evernote::Note::Markdown;

my $enex_file = "EvernoteExport.enex";
my $parser = Evernote::EnexParser->new(xmlfile => $enex_file, body_parser => Evernote::Note::Markdown->new );
my @notes = $parser->notes;
foreach my $note ( @notes ) {
    printf "Title: %s\n", $note->title;
    printf "Tags:  %s\n", join(", ", @{$note->tags} );
    printf "RawBody: %s\n", $note->raw_body;
}
```

Parsing the body is the tricky part. Evernote has special tags for pictures, videos, etc. This at least gives you a easier access to the different parts of the note. The parsing is pluggable -- if you find a better way to create the Markdown, you can create a perl module with the ```parse``` method, and pass an instance of your module to the script. Your parse method will be called to generate the body.


## Starter Script

I've included a starter script ```en2something.pl``` to get you started. Use it by calling it as

```
PERL5LIB=lib ./en2something.pl --output output-dir --enex path/to/exportedNotes.enex --template templates/t1.body.tt --tagspaces
```
It will parse the notes and print out the title of each note. Files will be created as markdown in the output-dir. How the note is written is determined by the template (using Template::Toolkit). If --tagspaces is given, the tags will be inserted into the filename.

There is an example enex file in the ```t``` folder for reference.

# Limitations

No media is handled. Images and videos are ignored. I'll see what I can do about that.
