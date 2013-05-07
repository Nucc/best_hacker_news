# Leaderboard

## Installing

    $ bundle install

You will need Redis server on your machine. You can find description about installation on http://redis.io/download.

## Run

    $ [redis]/src/redis-server &
    $ rake "send_news_stat[your@email.address]"