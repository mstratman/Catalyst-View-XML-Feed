#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use XML::Feed;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

# make sure testapp works
BEGIN { use_ok 'TestApp'; }

# a live test against TestApp, the test application
use Test::WWW::Mechanize::Catalyst 'TestApp';
my $mech = Test::WWW::Mechanize::Catalyst->new;
$mech->get_ok('http://localhost/', 'get main page');
$mech->content_like(qr/it works/i, 'main page has our text');


subtest 'custom_formats' => sub {
    for my $action (qw(
        string
        feed_obj_entries_arrayref_objs__rss
        feed_obj_array_entries_array_objs__rss
        feed_hash_entries_objs__rss feed_hash_entries_objs__atom
        feed_hash_entries_hashes__rss
        ))
    {
        test_action($mech, $action);
    }
};

subtest 'xml_feed' => sub {
    for my $action (qw(
        xml_feed__atom xml_feed__rss xml_feed__rss09
        xml_feed__rss1 xml_feed__rss2
        ))
    {
        test_action($mech, $action);
    }
};

subtest 'xml_rss' => sub {
    eval { require XML::RSS; };
    plan(skip_all => 'XML::RSS not installed') if $@;
    for my $action (qw(xml_rss))
    {
        test_action($mech, $action);
    }
};

subtest 'xml_atom_simplefeed' => sub {
    eval { require XML::Atom::SimpleFeed; };
    plan(skip_all => 'XML::Atom::SimpleFeed not installed') if $@;
    for my $action (qw(xml_atom_simplefeed))
    {
        test_action($mech, $action);
    }
};

subtest 'xml_atom_feed' => sub {
    eval { require XML::Atom::Feed; };
    plan(skip_all => 'XML::Atom::Feed not installed') if $@;
    for my $action (qw(xml_atom_feed))
    {
        test_action($mech, $action);
    }
};

sub test_action {
    my ($mech, $action) = @_;
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

    SKIP: {
        skip "No author or description expected for RSS 0.9", 2
            if $mech->content =~ m!http://my.netscape.com/rdf/simple/0.9/!i;
        $mech->content_like(qr/it works/i, "/$action has 'it works'");
        $mech->content_like(qr/Mark A\. Stratman/i, "/$action has 'Mark A. Stratman'");
    }
}

done_testing;
