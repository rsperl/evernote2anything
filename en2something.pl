#!/usr/bin/env perl -w

use strict;
use Carp;
use FindBin;
use Template;
use Evernote::EnexParser;
use Evernote::Note::Markdown;
use Getopt::Long;

$SIG{__DIE__} = sub { confess shift };

my ($enex, $outputdir, $template, $tagspaces);
GetOptions(
    "enex:s"      => \$enex,
    "outputdir:s" => \$outputdir,
    "tagspaces"   => \$tagspaces,
    "template:s"  => \$template,
);
die "Could not find enex file"     unless -r $enex;
die "Could not find template file" unless -r $template;

mkdir $outputdir unless -d $outputdir;

my $enc = Evernote::EnexParser->new(
                        xmlfile     => $enex,
                        body_parser => Evernote::Note::Markdown->new
                    );
my @notes = $enc->notes;

my $tt = Template->new;
foreach my $n (@notes) {

    my @tags = @{ $n->tags };
    my $fn = "$outputdir/" . $n->normalize_title;
    if( $tagspaces ) {
        push @tags, $n->created->ymd("");
        $fn .= "[" . join(" ", @tags) . "]";
    }
    $fn .= ".md";
    my $vars = {
        title       => $n->title,
        tags_string => join(", ", @tags),
        body        => $n->body,
        author      => $n->author,
        created     => $n->created->ymd . $n->created->hms,
        updated     => $n->updated->ymd . $n->updated->hms,
        source      => $n->source
    };
    printf "Saving %s\n", $fn;
    $tt->process($template, $vars, $fn) || die $tt->error();
}
