Overview
========
nanocloud is aimed to provide an application wrapper around the [nanoc](ddfreyne/nanoc) library.

It runs on heroku and allows for in- and output to amazon S3 buckets.

Configuration
=============
All site configurations (in- and output bucket names) are stored in the Website model.

Amazon credentials are stored inside the user model.

ENV[HEROKU_API_KEY] has to be set, so that the heroku-api gem can start
and stop workers when needed!

