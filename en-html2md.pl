#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use Try::Tiny;
use Data::Dumper;
use Data::Printer;
use DateTime;
use Getopt::Long;
use EN;
use utf8;

my $DEBUG = ($ENV{DEBUG} && $ENV{DEBUG} == 1? 1 : 0);

my $input_file = shift @ARGV;
chomp $input_file;

try {
    my $output = EN->new(html_filename => $input_file)
                ->parse
                ->save;
    print "Saved $output\n";
} catch {
    print $_;
};

