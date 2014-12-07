package Evernote::Note::Raw;

use strict;
use Moose;

sub parse {
    my ($self, $raw_text) = @_;
    return $raw_text;
}

1;
