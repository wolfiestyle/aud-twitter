#!/usr/bin/perl
use strict;
use Config::Tiny;
use Net::Twitter;

my $config = Config::Tiny->read("$ENV{HOME}/.aud-twitter")
    or die "error reading config: @{[Config::Tiny->errstr]}\n";

my %oauth = map { $_ => ($config->{connect_params}->{$_} or die "invalid config: missing $_\n") }
    qw(consumer_key consumer_secret access_token access_token_secret);

my $tweet_before = $config->{tweet_params}->{before};
my $tweet_after = $config->{tweet_params}->{after};
my $tweet_extra = join ' ', @ARGV;

my $curr_song = `audtool current-song`;
chomp $curr_song;
die 'no current song' if !length($curr_song);

my $status = "$tweet_before $curr_song $tweet_after";
$status .= "// $tweet_extra" if length($tweet_extra);

print "sending tweet: $status\n";
my $api = Net::Twitter->new(traits => [qw/OAuth API::REST/], %oauth);
$api->update($status);
