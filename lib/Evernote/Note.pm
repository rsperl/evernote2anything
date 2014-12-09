package Evernote::Note;

use strict;
use Moose;
use DateTime;
use Data::Dumper;
use utf8;
use Encode;
use HTML::Entities;


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
    $title =~ s/{U+201C}/"/g;
    $title =~ s/{U+201D}/"/g;
    $title =~ s/[\|:]/-/g;
    $title =~ s/[\[\]'"?]//g;
    $title =~ s/^\.+//;
    $title =~ s/\.$//;
    return $title;
}

sub parse_body {
    my $self = shift;
    my $body = $self->body_raw;
    $body = decode_entities($body);
    $body = encode("utf8", $body);
    $body = $self->parser->parse( $body );
    $body =~ s/\x{00BF}//g; # remove unknown chars
    $body =~ s/\x{00BD}//g; # remove unknown chars
    $body =~ s/\x{00EF}//g; # remove unknown chars
    $body =~ s/\x{FFFD}//g; # remove unknown chars
    $self->body($body);
    return $self->body;
}

1;
