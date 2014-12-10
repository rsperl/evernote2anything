#!/usr/bin/env perl

use strict;
use XML::XSLT;
use Data::Dumper;

my $infile = shift @ARGV;
open my $fh, '<', $infile;
my $xmlstr = do { local $/; <$fh>; };
close $fh;

my $xslt = XML::XSLT->new("enml2html.xslt", warnings => 1);
$xslt->transform($xmlstr);
my $html = $xslt->toString();
print $html;
