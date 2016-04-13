#!/usr/bin/perl
use strict;
use warnings;
use JSON;

my $host = `hostname -f`;
chomp $host;
my $json;
my $buckets_dir = "/var/lib/ops-collectd-couchbase/data/";
my $buckets_file = "/var/lib/ops-collectd-couchbase/data/buckets";
open INPUT, "<", "$buckets_file";
while ( <INPUT> ) {
	chomp $_;
	`curl -s http://$host:8091/pools/default/buckets/$_/stats > $buckets_dir/$_.json`;
}
