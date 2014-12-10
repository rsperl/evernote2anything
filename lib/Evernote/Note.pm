package Evernote::Note;

use strict;
use Moose;
use DateTime;
use XML::Simple;
use Data::Dumper;


has parser     => (is => 'rw', isa => 'Object', required => 1);
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
has body_html  => (is => 'rw', isa => 'Str', default => '');
has body       => (is => 'rw', isa => 'Str', default => '');


sub BUILD {
    my ($self, $opts) = @_;
    $self->_enml2html;
    $self->parse_body;
}

sub normalize_title {
    my $self = shift;
    my $title = $self->title;
    $title =~ s/\N{U+201C}//g;
    $title =~ s/\N{U+201D}//g;
    $title =~ s/[\|:]/-/g;
    $title =~ s/[\[\]'"?]//g;
    $title =~ s/^\.+//;
    $title =~ s/\.$//;
    return $title;
}

sub _enml2html {
    my $self = shift;
    my $body = $self->body_raw;
    my $parser = XML::Simple->new;
    my $xml = $parser->XMLin($body);
    print Dumper($xml);
    $self->body_html($body);
    return $body;
}

sub parse_body {
    my $self = shift;
    $self->body($self->parser->parse( $self->body_html ));
    return $self->body;
}

1;
