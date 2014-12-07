#!/usr/bin/env perl

use strict;
use FindBin;
use Evernote::EnexParser;
use Evernote::Note::Markdown;


my $enex = shift @ARGV;
die "Could not find enex file" unless -r $enex;

my $enc = Evernote::EnexParser->new(xmlfile => $enex, body_parser => Evernote::Note::Markdown->new);
my @notes = $enc->notes;

foreach my $n (@notes) {
    printf "Title: %s\n",  $n->title;
    printf "Body:\n%s\n", $n->body;
}
