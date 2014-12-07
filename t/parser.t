use strict;
use Test::More;
use FindBin;

use_ok("Evernote::EnexParser");
use_ok("Evernote::Note");
use_ok("Evernote::Note::Markdown");

my $enex = shift @ARGV || "$FindBin::Bin/notes.enex";
die "Could not find enex file" unless -r $enex;

my $enc = Evernote::EnexParser->new(xmlfile => $enex, body_parser => Evernote::Note::Markdown->new);
isa_ok($enc, "Evernote::EnexParser");
my @notes = $enc->notes;

foreach my $n (@notes) {
    isa_ok($n, "Evernote::Note");
    note $n->title;
    note "body:\n" . $n->body;
}

done_testing;

