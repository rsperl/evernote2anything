#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use Try::Tiny;
use XML::Simple;
use Template;
use Data::Dumper;
use EN;
use DateTime;
use Getopt::Long;
use EN;
use utf8;

my $DEBUG = ($ENV{DEBUG} && $ENV{DEBUG} == 1? 1 : 0);


my ($TEMPLATE, $IMPORT_DIR, $OUTPUT_DIR, $EXT);
GetOptions(
    "template:s"   => \$TEMPLATE,
    "ext:s"        => \$EXT,
    "import-dir:s" => \$IMPORT_DIR,
    "output-dir:s" => \$OUTPUT_DIR,
);

if( ! ($IMPORT_DIR && $OUTPUT_DIR && $TEMPLATE) ) {
    print <<EOF;
Usage: $FindBin::Script --template <t> --ext <e> --import-dir <d> --output-dir <d>
    --import-dir d  Process files in this directory
    --output-dir d  Save converted files to this directory
    --template t    Template to use for writing out notes (see Template::Toolkit)
    --ext e         Extension to use for output files
EOF
    exit 1;
}

my $tt = Template->new;
my $wc = HTML::WikiConverter->new(dialect => "Markdown");

print "reading files from $IMPORT_DIR\n";
opendir(D, $IMPORT_DIR) or die "can't open import directory $IMPORT_DIR: $!\n";
my @files = readdir(D);
foreach my $file (@files) {
    my $in_file = "$IMPORT_DIR/$file";
    next unless -f $in_file && $in_file =~ /html$/;
    print "processing $in_file\n";
    my $en = EN->new(html_filename => $in_file);
    my $vars = {
        title       => $en->title,
        tags_string => join(", ", $en->tags),
        body        => $en->body,
        author      => $en->author,
        created     => $en->created,
        updated     => $en->updated,
        source      => $en->source,
    };
    my $normalized_title = $en->normalize_title;
    my $out_file         = "$OUTPUT_DIR/$normalized_title.$EXT";
    $tt->process($TEMPLATE, $vars, $out_file);
    print "saved as $out_file\n";
}

print "finished\n";

__END__

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
=======
my @files;
if( -f $input_file ) {
    @files = ($input_file);
} else {
    opendir D, $input_file;
    @files = map { "$input_file/$_" } readdir(D);
    closedir D;
}

foreach my $file (@files) {
    next unless -f $file && $file =~ /\.html$/;
    my $failed = 0;
    print "Migrating $file\n";
>>>>>>> 8827865911c5ef110e90d635cf24a8d2bc6ba4ea
    try {
        my $output = EN->new(html_filename => $file)
                    ->parse
                    ->save;
        print "Saved $output\n";
    } catch {
        $failed = 1;
        print "failed $file: $_";
    };

<<<<<<< HEAD
=======
    exit if $failed;
}
>>>>>>> 8827865911c5ef110e90d635cf24a8d2bc6ba4ea
