package Evernote::Note::Markdown;

use strict;
use Moose;
use HTML::WikiConverter;
use Try::Tiny;
use utf8;

my $wc   = HTML::WikiConverter->new(
                dialect     => "Markdown",
                link_style  => "inline",
                image_style => "inline",
                encoding    => "utf8",
                wrap_in_html => 1,
                md_extra    => 1,
            );

sub parse {
    my ($self, $raw_text) = @_;
    my $md;
    try {
        $md = $wc->html2wiki($raw_text);
        $md =~ s/\<br\s*\/\>//g;
        $md =~ s/\\_/_/g;
    } catch {
        $md = "Error converting to markdown: $_";
        $md .= $raw_text;
    };

    return $md;
}

1;
