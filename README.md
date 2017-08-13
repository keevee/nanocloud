Overview
========
nanocloud is aimed to provide an application wrapper around the [nanoc](ddfreyne/nanoc) library.

It runs on heroku and allows for in- and output to amazon S3 buckets.


Run locally
===========

delayed job:
NC_RUN_LOCAL=true script/delayed_job start

Configuration
=============
All site configurations (in- and output bucket names) are stored in the Website model.

Amazon credentials are stored inside the user model.
