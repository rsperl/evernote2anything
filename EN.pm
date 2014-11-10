package EN;

use strict;
use Moose;
use Mojo::DOM;
use DateTime;
use Mojo::Collection;
use HTML::WikiConverter;
use Data::Dumper;


has html_filename => (is => 'ro', isa => 'Str', required => 1);
has input_html => (is => 'rw', isa => 'Str',      required     => 0);

has tags        => (is => 'rw', isa => 'ArrayRef', default => sub {[]});
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
my $wc   = HTML::WikiConverter->new(
                dialect    => "Markdown",
                link_style => "inline",
                image_style => "inline",
                md_extra   => 1,
            );

sub BUILD {
    my ($self, $opts) = @_;
    open my $fh, '<', $opts->{html_filename} or die "Can't open $opts->{html_filename}: $!";
    $opts->{input_html} = do { local $/; <$fh>; };
    $opts->{input_html} =~ s/<a name="\d+?"\/>//;
    $self->input_html( $opts->{input_html} );
    close $fh;
    if(
        index($opts->{input_html}, "<img") != -1
    ) {
        #die "$opts->{html_filename} contains images"
    }
}

sub normalize_title {
    my $self = shift;
    my $title = $self->title;

    return $title;
}

sub parse {
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

    $self->body($wc->html2wiki($self->input_html));
    return $self;
}
