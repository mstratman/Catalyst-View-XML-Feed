package TestApp::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => q{});

sub base : Chained('/') PathPart('') CaptureArgs(0) {}

# your actions replace this one
sub main : Chained('base') PathPart('') Args(0) {
    my ($self, $ctx) = @_;
    $ctx->res->body('<h1>It works</h1>');
}

sub string : Local {
    my ($self, $c) = @_;
    $c->stash->{feed} = q{<?xml version="1.0" encoding="UTF-8" ?>
    <rss version="2.0">

    <channel>
    <title>My Feed Site</title>
    <description>This is an example</description>
    <link>http://www.example.com/link.htm</link>
    <lastBuildDate>Mon, 28 Aug 2006 11:12:55 -0400 </lastBuildDate>
    <pubDate>Tue, 29 Aug 2006 09:00:00 -0400</pubDate>
    <item>
    <title>It Works!</title>
    <description>Yesss.... it works!</description>
    <link>http://www.example.com/link.htm</link>
    <guid isPermaLink="false"> 1102345</guid>
    <pubDate>Tue, 29 Aug 2006 09:00:00 -0400</pubDate>
    </item>
    </channel>
    </rss>};
    $c->forward('View::Feed');
}

sub xml_feed : Local {
    my ($self, $c) = @_;

    my $feed = XML::Feed->new('Atom');
    $feed->id($c->req->base);
    $feed->title('My Feed Site');
    $feed->description('This is an example');
    $feed->link($c->req->base);
    $feed->modified(DateTime->now);
    my $entry = XML::Feed::Entry->new();
    $entry->id('tag:example.com,' . time());
    $entry->link($c->uri_for('rss_xml_feed', 'first_post')->as_string);
    $entry->title('It Works!');
    $entry->content('Yesss.... it works!');
    $feed->add_entry($entry);

    $c->stash->{feed} = $feed;
    $c->forward('View::Feed');
}

__PACKAGE__->meta->make_immutable;
