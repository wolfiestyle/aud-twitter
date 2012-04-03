#!/usr/bin/perl
use strict;
use Config::Tiny;
use Net::Twitter;

my $config = Config::Tiny->read("$ENV{HOME}/.aud-twitter")
    or die("error reading config: " . Config::Tiny->errstr . "\n");

sub cfg_read { $config->{connect_params}->{$_[0]} or die("invalid config: missing $_[0]\n"); }

my $consumer_key = cfg_read('CONSUMER_KEY');
my $consumer_secret = cfg_read('CONSUMER_SECRET');
my $access_token_key = cfg_read('ACCESS_TOKEN_KEY');
my $access_token_secret = cfg_read('ACCESS_TOKEN_SECRET');

my $tweet_before = $config->{tweet_params}->{BEFORE};
my $tweet_after = $config->{tweet_params}->{AFTER};
my $tweet_extra = join ' ', @ARGV;

my $curr_song = `audtool current-song`;
chomp $curr_song;
die('no current song') if (!length($curr_song));

my $status = "$tweet_before $curr_song $tweet_after";
$status .= "// $tweet_extra" if (length($tweet_extra));

my $api = Net::Twitter->new(
    traits => [qw/OAuth API::REST/],
    consumer_key => $consumer_key,
    consumer_secret => $consumer_secret,
    access_token => $access_token_key,
    access_token_secret => $access_token_secret,
);
$api->update($status);
