#!/usr/bin/env perl

use 5.12.4;
use strict;
use warnings;
use Mojo::DOM;
use Try::Tiny;
use XML::Simple;
use Data::Dumper;
use Data::Printer;
use DateTime;
use HTML::WikiConverter::Markdown;
use utf8;

my $DEBUG = ($ENV{DEBUG} && $ENV{DEBUG} == 1? 1 : 0);

if (! @ARGV) {
    print "Usage: $0 file.enex\n";
    exit;
}

my $filename = shift @ARGV;
chomp $filename;
my $parser = XML::Simple->new;
my $wc = HTML::WikiConverter->new(dialect => "Markdown");
my $xml = $parser->XMLin($filename);
foreach my $note ( @{$xml->{note}} ) {
    my $parsed_note = parse_note($note);
    save_note($parsed_note);
}

sub save_note {
    my $note = shift;
    print "start tags: " . Dumper($note->{tags}) . "\n";
    my @tags = sort
                    @{$note->{tags}},
                    $note->{created}->ymd("") . '-' . $note->{created}->hms("");;
    for(my $i=0; $i<@tags; $i++) {
        $tags[$i] =~ s/\s+/_/g;
    }
    my $tags = join(' ', @tags);
    my $filename = $note->{title} . "[$tags].md";
    print "filename: $filename\n";
    open my $fh , '>', $filename;
    print $fh $note->{content};
    close $fh;
}

sub parse_note {
    my $note = shift;
    my $title = $note->{title};
    my @tags;
    if( exists $note->{tag} ) {
        if( ref($note->{tag}) eq 'ARRAY' ) {
            @tags = @{$note->{tag}};
        } elsif( ref($note->{tag}) eq '' ) {
            @tags = ( $note->{tag} );
        }
    }
    my $content = "";
    try {
        $content = $wc->html2wiki($note->{content});
        $content =~ s/\\x{(.+?)}/chr(hex($1))/ge;
        # $content =~ s/(.)/(ord($1) > 127) ? "" : $1/egs;
    } catch {
        $content = $_;
    };
    my $dt_created;
    if( $note->{created} =~ /^(\d\d\d\d)(\d\d)(\d\d)T(\d\d)(\d\d)(\d\d)Z$/ ) {
        $dt_created = DateTime->new(
                            time_zone => "UTC", year => $1, month => $2, day => $3,
                            hour => $4, minute => $5, second => $6
                        );
    } else {
        print "bad created time: $note->{created}\n";
    }
    return {
        title   => $title,
        tags    => \@tags,
        content => $content,
        created => $dt_created,
    };
}
