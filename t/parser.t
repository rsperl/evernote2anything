use strict;
use Test::More;
use FindBin;

use_ok("Evernote::EnexParser");
use_ok("Evernote::Note");

my $enex = shift @ARGV || "$FindBin::Bin/notes.enex";
die "Could not find enex file" unless -r $enex;

my $enc = Evernote::EnexParser->new(xmlfile => $enex);
isa_ok($enc, "Evernote::EnexParser");
my @notes = $enc->notes;

foreach my $n (@notes) {
    isa_ok($n, "Evernote::Note");
    note $n->title;
}

done_testing;

