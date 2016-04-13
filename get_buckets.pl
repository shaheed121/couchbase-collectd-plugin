#!/usr/bin/perl
use strict;
use warnings;
use JSON;

my $hostname = `hostname -f`;
chomp $hostname;
my $out = `curl -s http://$hostname:8091/pools/default/buckets > /var/lib/ops-cosmos-couchbase/data/buckets.json`;
my $json_file = "/var/lib/ops-cosmos-couchbase/data/buckets.json";
my $bucket_file = "/var/lib/ops-cosmos-couchbase/data/buckets";
my $json;
{
  local $/;
  open my $fh, "<", "$json_file";
  $json = <$fh>;
  close $fh;
}

open ( my $fh, ">" , $bucket_file ) or die "$!";
my $ref = decode_json($json);
for (@{$ref}) {
	print $fh $_->{name},"\n";
}
