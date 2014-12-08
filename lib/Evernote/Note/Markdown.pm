package Evernote::Note::Markdown;

use strict;
use Moose;
use HTML::WikiConverter;
use Try::Tiny;

my $wc   = HTML::WikiConverter->new(
                dialect     => "Markdown",
                link_style  => "inline",
                image_style => "inline",
                md_extra    => 1,
            );

sub parse {
    my ($self, $raw_text) = @_;
    my $md;
    try {
        $md = $wc->html2wiki($raw_text);
    } catch {
        $md = "Error converting to markdown: $_";
        $md .= $raw_text;
    };

    return $md;
}

1;
