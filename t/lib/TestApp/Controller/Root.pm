package TestApp::Controller::Root;
use Moose;
use namespace::autoclean;
use DateTime;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => q{});

sub _feed_link :Private { return $_[1]->req->base; }
sub _feed_base :Private { return $_[1]->req->base; }
sub _feed_title :Private { return 'My awesome site'; }
sub _feed_tagline :Private { return 'A great tagline'; }
sub _feed_description :Private { return 'The greatest site ever'; }
sub _feed_author :Private { return 'Mark A. Stratman'; }
sub _feed_language :Private { return 'English'; }
sub _feed_copyright :Private { return 'Copyright me 2011'; }
sub _feed_generator :Private { return 'Catalyst::View::XML::Feed ' . $Catalyst::View::XML::Feed::VERSION; }
sub _feed_id : Private { return _feed_link(@_); }

sub _entry_title : Private { return 'My first post' }
sub _entry_base : Private { $_[1]->uri_for('/', 'my_first_post'); }
sub _entry_link : Private { $_[1]->uri_for('/', 'my_first_post'); }
sub _entry_content : Private { return 'It works! And even more stuff here' }
sub _entry_summary : Private { return 'It wor...' }
sub _entry_category : Private { return 'Junk' }
sub _entry_author : Private { return _feed_author(@_) }
sub _entry_id : Private { return _entry_link(@_) }
sub _now : Private { return DateTime->now }

sub index : Path  {
    my ($self, $ctx) = @_;
    $ctx->res->body('<h1>It works</h1>');
}

sub string : Local {
    my ($self, $c) = @_;
    $c->stash->{feed} = q{<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
 xml:base="http://localhost:3000/"
 xmlns:blogChannel="http://backend.userland.com/blogChannelModule"
 xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
 xmlns:content="http://purl.org/rss/1.0/modules/content/"
 xmlns:atom="http://www.w3.org/2005/Atom"
 xmlns:dcterms="http://purl.org/dc/terms/"
>

<channel>
<title>My awesome site</title>
<link>http://localhost:3000/</link>
<description>A great tagline</description>
<copyright>Copyright me 2011</copyright>
<pubDate>Wed, 23 Mar 2011 00:34:40 -0000</pubDate>
<webMaster>Mark A. Stratman</webMaster>
<generator>Catalyst::View::XML::Feed 0.01</generator>

<item>
<title>My first post</title>
<link>http://localhost:3000/my_first_post</link>
<description>It wor...</description>
<author>Mark A. Stratman</author>
<category>Junk</category>
<guid isPermaLink="true">http://localhost:3000/my_first_post</guid>
<pubDate>Wed, 23 Mar 2011 00:34:40 -0000</pubDate>
<content:encoded>It works! And even more stuff here</content:encoded>
<dcterms:modified>2011-03-23T00:34:40Z</dcterms:modified>
</item>
</channel>
</rss>};
    $c->forward('View::Feed');
}


sub _xml_feed : Private {
    my ($self, $c, @format) = @_;

    my $feed = XML::Feed->new(@format);
    $feed->id($self->_feed_id($c));
    $feed->title($self->_feed_title($c));
    $feed->description($self->_feed_description($c));
    $feed->link($self->_feed_link($c));
    $feed->modified($self->_now($c));
    $feed->base($self->_feed_base($c));
    $feed->tagline($self->_feed_tagline($c));
    $feed->author($self->_feed_author($c));
    $feed->copyright($self->_feed_copyright($c));
    $feed->generator($self->_feed_generator($c));

    my $entry = XML::Feed::Entry->new();
    $entry->title($self->_entry_title($c));
    $entry->base($self->_entry_base($c));
    $entry->link($self->_entry_link($c));
    $entry->content($self->_entry_content($c));
    $entry->summary($self->_entry_summary($c));
    $entry->category($self->_entry_category($c));
    $entry->author($self->_entry_author($c));
    $entry->id($self->_entry_id($c));
    $entry->issued($self->_now($c));
    $entry->modified($self->_now($c));
    $feed->add_entry($entry);

    return $feed;
}

sub atom_xml_feed : Local {
    my ($self, $c) = @_;
    $c->stash->{feed} = $self->_xml_feed($c, 'Atom');
    $c->forward('View::Feed');
}
sub rss_xml_feed : Local {
    my ($self, $c) = @_;
    $c->stash->{feed} = $self->_xml_feed($c, 'RSS');
    $c->forward('View::Feed');
}
sub rss09_xml_feed : Local {
    my ($self, $c) = @_;
    $c->stash->{feed} = $self->_xml_feed($c, 'RSS', version => '0.9');
    $c->forward('View::Feed');
}
sub rss1_xml_feed : Local {
    my ($self, $c) = @_;
    $c->stash->{feed} = $self->_xml_feed($c, 'RSS', version => '1.0');
    $c->forward('View::Feed');
}
sub rss2_xml_feed : Local {
    my ($self, $c) = @_;
    $c->stash->{feed} = $self->_xml_feed($c, 'RSS', version => '2.0');
    $c->forward('View::Feed');
}

__PACKAGE__->meta->make_immutable;
