package Evernote::Note;

use strict;
use Moose;
use Mojo::DOM;
use DateTime;
use Mojo::Collection;
use HTML::WikiConverter;
use Data::Dumper;


has tags       => (is => 'rw', isa => 'ArrayRef', default => sub {[]});
has created    => (is => 'rw', isa => 'DateTime', default => sub { DateTime->now });
has author     => (is => 'rw', isa => 'Str', default => '');
has source     => (is => 'rw', isa => 'Str', default => '');
has title      => (is => 'rw', isa => 'Str', default => '');
has updated    => (is => 'rw', isa => 'DateTime', default => sub { DateTime->now });
has longtitude => (is => 'rw', isa => 'Num', default => '');
has latitude   => (is => 'rw', isa => 'Num', default => '');
has altitude   => (is => 'rw', isa => 'Num', default => '');
has body_raw   => (is => 'rw', isa => 'Str', default => '');

my $html = Mojo::DOM->new;
my $wc   = HTML::WikiConverter->new(
                dialect    => "Markdown",
                link_style => "inline",
                image_style => "inline",
                md_extra   => 1,
            );

sub BUILD {
    my ($self, $opts) = @_;
}

sub normalize_title {
    my $self = shift;
    my $title = $self->title;

    $title =~ s/[\|:]/-/g;

    return $title;
}

sub parse_body {
    my ($self) = @_;

    my $dom = $html->parse($self->input_html);
    my $title = $dom->find("html title")->[0]->text;
    $self->title($title);

    my $tables = $dom->find("html body div table");
    my $row_nodes = Mojo::Collection->new;
    if( $tables->[0] ) {
        $row_nodes = $tables->[0]->find("tr");
    }

    $row_nodes->each(sub {
            my ($e, $count) = @_;
            my $row_dom = Mojo::DOM->new()->parse("" . $e);
            my $name = lc($row_dom->find("b")->[0]->text);
            $name =~ s/:$//;
            my $value = "";
            if( $row_dom->find("i")->[0] ) {
                $value = $row_dom->find("i")->[0]->text;
            }
            if( $name =~ /tags/i ) {
                my @a = split(/,/, $value);
                for(my $i=0; $i<@a; $i++) {
                    $a[$i] =~ s/^\s+//;
                    $a[$i] =~ s/\s+$//;
                    $a[$i] =~ s/\s+/_/g;
                }
                $self->$name(\@a);
            } else {
                $self->$name($value);
            }

        }
    );

    my $body = $wc->html2wiki($self->input_html);
    $body =~ s/\<br\s*?\/\>/\n/g;
    $body =~ s/\n\n/\n/gm;
    $self->body($body);
    return $self;
}

1;
