#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

# make sure testapp works
use ok 'TestApp';

# a live test against TestApp, the test application
use Test::WWW::Mechanize::Catalyst 'TestApp';
my $mech = Test::WWW::Mechanize::Catalyst->new;
$mech->get_ok('http://localhost/', 'get main page');
$mech->content_like(qr/it works/i, 'main page has our text');


for my $action (qw(string atom_xml_feed rss_xml_feed rss09_xml_feed rss1_xml_feed rss2_xml_feed)) {
    $mech->get_ok("http://localhost/$action", "get /$action");
    my $ct = 'text/xml';
    if ($action =~ /rss/) {
        $ct = 'application/rss+xml';
    } elsif ($action =~ /atom/) {
        $ct = 'application/atom+xml';
    }
    cmp_ok($mech->content_type, 'eq', $ct, "/$action has correct content_type");
    $mech->content_like(qr/my awesome site/i, "/$action has 'my awesome site'");
    $mech->content_like(qr/my first post/i, "/$action has 'my first post'");
    $mech->content_like(qr/my_first_post/i, "/$action has 'my_first_post'");
    unless ($mech->content =~ m!http://my.netscape.com/rdf/simple/0.9/!i) {
        $mech->content_like(qr/it works/i, "/$action has 'it works'");
        $mech->content_like(qr/Mark A\. Stratman/i, "/$action has 'Mark A. Stratman'");
    }
}

done_testing;
