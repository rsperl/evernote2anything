#!/usr/bin/env perl

use strict;
use FindBin;
use Evernote::EnexParser;


my $enex = shift @ARGV;
die "Could not find enex file" unless -r $enex;

my $enc = Evernote::EnexParser->new(xmlfile => $enex);
isa_ok($enc, "Evernote::EnexParser");
my @notes = $enc->notes;

foreach my $n (@notes) {
    note $n->title;
}
