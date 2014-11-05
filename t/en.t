use strict;
use warnings;

use Test::More;
use lib '..';
use_ok("EN");

my $html = do { local $/; <DATA>; };
my $en = EN->new(input_html => $html);
isa_ok($en, "EN");
is($en->input_html, $html, "got html back");

$en->parse;

my $exp_title = "with video";
my $exp_tags  = "funny, tag2";
my $exp_src   = "https://pbs.twimg.com/tweet_video/BzyRPhOIAAAKnKz.mp4";
my $exp_auth  = "Richard Sugg";
my $exp_created = '10/19/2014 4:20 PM';
my $exp_updated = '11/4/2014 11:26 AM';
is($en->title,  $exp_title, "got title");
is($en->tags,   $exp_tags,  "got tags");
is($en->source, $exp_src,   "got source");
is($en->author, $exp_auth,  "got author");
is($en->created, $exp_created, "got created");
is($en->updated, $exp_updated, "got updated");

done_testing;



__DATA__
<html>
<head>
  <title>with video</title>
  <basefont face="Droid Sans Mono" size="2" />
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
  <meta name="exporter-version" content="Evernote Windows/273492; Windows/6.1.7601 Service Pack 1;"/>
  <style>
    body, td {
      font-family: Droid Sans Mono;
      font-size: 10pt;
    }
  </style>
</head>
<body>
<a name="23519"/>
<h1>with video</h1>
<div>
<table bgcolor="#D4DDE5" border="0">
<tr><td><b>Created:</b></td><td><i>10/19/2014 4:20 PM</i></td></tr>
<tr><td><b>Updated:</b></td><td><i>11/4/2014 11:26 AM</i></td></tr>
<tr><td><b>Author:</b></td><td><i>Richard Sugg</i></td></tr>
<tr><td><b>Tags:</b></td><td><i>funny, tag2</i></td></tr>
<tr><td><b>Source:</b></td><td><a href="https://pbs.twimg.com/tweet_video/BzyRPhOIAAAKnKz.mp4"><i>https://pbs.twimg.com/tweet_video/BzyRPhOIAAAKnKz.mp4</i></a></td></tr>
</table>
</div>
<br/>

<div>
<div>
<div><a href="with video_files/funny fountain video.mp4"><img src="with video_files/a75ef9c3a5787a274effdf765cc6caaf.png" alt="funny fountain video.mp4"></a></div>
</div>
</div></body></html>
