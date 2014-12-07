package Evernote::Note::Markdown;

use strict;
use Moose;
use Mojo::Collection;
use HTML::WikiConverter;

my $wc   = HTML::WikiConverter->new(
                dialect     => "Markdown",
                link_style  => "inline",
                image_style => "inline",
                md_extra    => 1,
            );

sub parse {
    my ($self, $raw_text) = @_;
    my $md = $wc->html2wiki($raw_text);
    return $md;
}

1;
