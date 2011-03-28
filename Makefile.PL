use strict;
use warnings;
use inc::Module::Install 0.91;

name 'Catalyst-View-XML-Feed';
all_from 'lib/Catalyst/View/XML/Feed.pm';

requires 'Moose';
requires 'namespace::autoclean';
requires 'XML::Feed' => '0.43';

build_requires 'Catalyst::Runtime' => '5.80015';
build_requires 'Test::WWW::Mechanize::Catalyst';
build_requires 'Test::More' => '0.88';
build_requires 'DateTime';

resources repository => 'https://github.com/mstratman/Catalyst-View-XML-Feed';

WriteAll();
