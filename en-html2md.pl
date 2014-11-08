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
    try {
        my $output = EN->new(html_filename => $file)
                    ->parse
                    ->save;
        print "Saved $output\n";
    } catch {
        $failed = 1;
        print "failed $file: $_";
    };

    exit if $failed;
}
