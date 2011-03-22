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

$mech->get_ok('http://localhost/string', 'get /string');
cmp_ok($mech->content_type, 'eq', 'text/xml', '/string has correct content_type');
$mech->content_like(qr/it works/i, '/string has our text');

#$mech->get_ok('http://localhost/perl_data', 'get xml from perl data');

#die 'WTF:'. $mech->content_type;
#$mech->content_like(qr/it works/i, 'see if it has our text');
# TODO: write test cases for each possible type of 'entries'

done_testing;
