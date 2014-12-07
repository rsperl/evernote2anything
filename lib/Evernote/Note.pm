package Evernote::Note;

use strict;
use Moose;
use DateTime;
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
has body       => (is => 'rw', isa => 'Str', default => '');


sub BUILD {
    my ($self, $opts) = @_;
    $self->parse_body;
}

sub normalize_title {
    my $self = shift;
    my $title = $self->title;
    $title =~ s/[\|:]/-/g;
    return $title;
}

sub parse_body {
    my $self = shift;
    $self->body($self->parser->parse( $self->body_raw ));
    return $self->body;
}

1;
