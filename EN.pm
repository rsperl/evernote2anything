package EN;

use strict;
use Moose;
use Mojo::DOM;
use DateTime;
use HTML::WikiConverter::Markdown;
use Data::Dumper;


has input_html => (is => 'ro', isa => 'Str',      required     => 1);

has tags       => (is => 'rw', isa => 'Str', default => '');
#has created    => (is => 'rw', isa => 'DateTime', default => sub { DateTime->now });
has created    => (is => 'rw', isa => 'Str', default => '');
has author     => (is => 'rw', isa => 'Str', default => '');
has source     => (is => 'rw', isa => 'Str', default => '');
has title      => (is => 'rw', isa => 'Str', default => '');
#has updated    => (is => 'rw', isa => 'DateTime', default => sub { DateTime->now });
has updated    => (is => 'rw', isa => 'Str', default => '');
has location   => (is => 'rw', isa => 'Str', default => '');
has body       => (is => 'rw', isa => 'Str', default => '');

my $html = Mojo::DOM->new;
my $wc   = HTML::WikiConverter::Markdown->new(dialect => "Markdown");

sub BUILD {
    my ($self, $opts) = @_;
}

sub parse {
    my ($self) = @_;
    my $dom = $html->parse($self->input_html);
    my $title = $dom->find("html title")->[0]->text;
    $self->title($title);

    my $row_nodes = $dom->find("html body div table tr");

    $row_nodes->each(sub {
            my ($e, $count) = @_;
            my $row_dom = Mojo::DOM->new()->parse("" . $e);
            my $name = lc($row_dom->find("b")->[0]->text);
            $name =~ s/:$//;
            my $value = $row_dom->find("i")->[0]->text;
            $self->$name($value);
        }
    );
}
