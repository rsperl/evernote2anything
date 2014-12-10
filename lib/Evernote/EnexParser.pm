package Evernote::EnexParser;

use strict;
use Moose;
use Data::Dumper;
use FindBin;
use DateTime;
use XML::Simple;
use XML::XSLT;
use Evernote::Note;

use utf8;

has xmlfile => (is => 'rw', isa => 'Str', required => 1);
has body_parser => (is => 'rw', isa => 'Object', required => 1);

my $xmlparser = XML::Simple->new;
my $xml;
my @parsed_notes;
my $xslt;

sub BUILD {
    my ($self, $opts) = @_;
    my $xslt_file = "$FindBin::Bin/enml2html.xslt";
    open my $fh, '<', $xslt_file;
    my $xsl = do { local $/; <$fh>; };
    close $fh;
    $xslt = XML::XSLT->new ($xsl, warnings => 1);
}

sub dump_xml {
    print Dumper($xml);
}

sub _read_enex {
    my $self = shift;
    @parsed_notes = ();
    $xml = $xmlparser->XMLin($self->xmlfile);
}

sub _parse_notes {
    my ($self) = @_;
    $self->_read_enex;
    # todo - loop through XML notes and parse notes

    foreach my $n ( @{$xml->{note}} ) {
        my @tags;
        my ($dt_created, $author, $source, $dt_updated, $location, $body, $title);

        if( $n->{created} =~ /^(\d\d\d\d)(\d\d)(\d\d)T(\d\d)(\d\d)(\d\d)Z$/ ) {
            $dt_created = DateTime->new(
                                year => $1, month  => $2, day => $3,
                                hour => $4, minute => $5, second => $6,
                                time_zone => "America/New_York");
        }
        if( $n->{updated} && $n->{updated} =~ /^(\d\d\d\d)(\d\d)(\d\d)T(\d\d)(\d\d)(\d\d)Z$/ ) {
            $dt_updated = DateTime->new(
                                year => $1, month => $2,  day => $3,
                                hour => $4, minute => $5, second => $6,
                                time_zone => "America/New_York");
        } else {
            $dt_updated = DateTime->now(time_zone => "America/New_York");
        }

        my $attrs = $n->{'note-attributes'};
        my $tags;
        if( ref($n->{tag}) eq 'ARRAY' ) {
            $tags = $n->{tag};
        } else {
            $tags = [ $n->{tag} ];
        }
        $tags = [] if ! $tags || ref($tags) ne 'ARRAY';

        my $html = $xslt->transform($n->{content})->toString();
        print "HTML: $html\n";

        push(@parsed_notes, new Evernote::Note(
                parser     => $self->body_parser,
                tags       => $tags,
                created    => $dt_created,
                updated    => $dt_updated,
                title      => $n->{title},
                author     => $attrs->{author} || "",
                source     => $attrs->{source} || "",
                longtitude => $n->{longtitude} || 0,
                latitude   => $n->{latitude}   || 0,
                altitude   => $n->{altitude}   || 0,
                body_raw   => $n->{content},
                body_html  => $html,
            )
        );
    }
}

sub notes {
    my ($self, $do_not_reparse_xml) = @_;
    $self->_parse_notes unless $do_not_reparse_xml;
    return @parsed_notes;
}

1;
