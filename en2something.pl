#!/usr/bin/env perl -w

use strict;
use Carp;
use FindBin;
use Template;
use Evernote::EnexParser;
use Evernote::Note::Markdown;
use Getopt::Long;
use utf8;

$SIG{__DIE__} = sub { confess shift };

my ($enex, $outputdir, $template, $tagspaces, $extension, $omit_tags);
$extension = "md";
GetOptions(
    "enex:s"      => \$enex,
    "outputdir:s" => \$outputdir,
    "tagspaces"   => \$tagspaces,
    "template:s"  => \$template,
    "extension:s" => \$extension,
    "omit-tags:s" => \$omit_tags,
);
die "Could not find enex file"     unless -r $enex;
die "Could not find template file" unless -r $template;

my @omit_tags;
@omit_tags = split(/\s*,\s*/, $omit_tags) if $omit_tags;

mkdir $outputdir unless -d $outputdir;

my $enc = Evernote::EnexParser->new(
                        xmlfile     => $enex,
                        body_parser => Evernote::Note::Markdown->new
                    );
my @notes = $enc->notes;

my $tt = Template->new(
            ENCODING => 'utf8'
        );
foreach my $n (@notes) {

    my @tmptags = @{ $n->tags };
    my @tags;
    foreach my $ft (@tmptags) {
        push @tags, $ft unless grep({/^$ft$/} @omit_tags);
    }
    my $fn = "$outputdir/" . $n->normalize_title;
    if( $tagspaces ) {
        push @tags, $n->created->ymd("");
        my $tag_str = join(" ", @tags);
        $tag_str =~ s/^\s+//;
        $tag_str =~ s/\s+$//;
        $fn .= "[" . $tag_str . "]";
    }
    $fn .= ".$extension";
    my $vars = {
        title       => $n->title,
        tags_string => join(", ", @tags),
        body        => $n->body,
        author      => $n->author,
        created     => $n->created->ymd . ' ' . $n->created->hms,
        updated     => $n->updated->ymd . ' ' . $n->updated->hms,
        source      => $n->source
    };
    printf "Saving %s\n", $fn;
    $tt->process($template, $vars, $fn, binmode => ':encoding(utf8)') || die $tt->error();
}
