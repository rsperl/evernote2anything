#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use Try::Tiny;
use XML::Simple;
use Data::Dumper;
use Data::Printer;
use DateTime;
use HTML::WikiConverter::Markdown;
use Getopt::Long;
use utf8;

my $DEBUG = ($ENV{DEBUG} && $ENV{DEBUG} == 1? 1 : 0);

my @DO_NOT_CONVERT_IF_TAGGED = qw(markdown);

my ($IMPORT_FILE, $OUTPUT_DIR);
GetOptions(
    "import:s" => \$IMPORT_FILE,
    "output-dir:s" => \$OUTPUT_DIR,
);

if( ! ($IMPORT_FILE && $OUTPUT_DIR) ) {
    print "Usage: $FindBin::Script --import <file.html> --output-dir <dir>\n";
    exit 1;
}

my $wc = HTML::WikiConverter->new(dialect => "Markdown");
open my $fh, '<', $IMPORT_FILE;
my $content = do { local $/; <$fh>; };
close $fh;
if( index($content, "<en-media") >= 0 ||
    index($content, "<en-todo")  >= 0 ) {
    $content = $wc->html2wiki($content);
open $fh, '>', "test_html.md";
print $fh $content;
close $fh;
print "finished\n";

__END__

foreach my $note ( @notes ) {
    print Dumper($note);
    exit;
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
    open my $fh , '>', "$OUTPUT_DIR/$filename";
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
        if( ! array_contains(\@DO_NOT_CONVERT_IF_TAGGED, \@tags) ) {
            $content = $wc->html2wiki($note->{content});
        }
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

sub array_contains {
    my ($needles, $haystack) = @_;
    die "needles must be an arrayref"  unless ref($needles)  eq 'ARRAY';
    die "haystack must be an arrayref" unless ref($haystack) eq 'ARRAY';
    foreach my $needle (@$needles) {
        return 1 if grep({/^$needle$/} @$haystack);
    }
    return 0;
}

