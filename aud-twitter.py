#!/usr/bin/python
#
# aud-twitter: Publish on twitter what you are listening on Audacious
# based on mpd-twitter by Zerial
#

import os, subprocess, ConfigParser, sys
from twitter import Api

config = ConfigParser.ConfigParser()
params = config.read(['/etc/aud-twitter.conf', os.path.expanduser('~/.aud-twitter')])

CONSUMER_KEY = config.get('connect_params', 'CONSUMER_KEY', 1)
CONSUMER_SECRET = config.get('connect_params', 'CONSUMER_SECRET', 1)
ACCESS_TOKEN_KEY = config.get('connect_params', 'ACCESS_TOKEN_KEY', 1)
ACCESS_TOKEN_SECRET = config.get('connect_params', 'ACCESS_TOKEN_SECRET', 1)

TWEET_BEFORE = config.get('tweet_params', 'BEFORE', 1)
TWEET_AFTER = config.get('tweet_params', 'AFTER', 1)
TWEET_EXTRA = sys.argv[1:]

curr_song = subprocess.Popen(['audtool', 'current-song'], stdout=subprocess.PIPE)
status = TWEET_BEFORE + ' ' + curr_song.stdout.read().rstrip() + ' ' + TWEET_AFTER
if len(TWEET_EXTRA):
    status += '// ' + ' '.join(TWEET_EXTRA)

api = Api(consumer_key=CONSUMER_KEY, consumer_secret=CONSUMER_SECRET, access_token_key=ACCESS_TOKEN_KEY, access_token_secret=ACCESS_TOKEN_SECRET)
new_status = api.PostUpdate(status)
