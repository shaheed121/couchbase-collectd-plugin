#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use JSON;

while (1) {
my $host = `hostname -f`;
chomp $host;
my $json;
my @buckets;
my $buckets_file = "/var/lib/ops-collectd-couchbase/data/buckets";
my @keys = qw ( hit_ratio ep_cache_miss_rate bytes_read bytes_written cmd_get cmd_set curr_connections curr_items decr_hits decr_misses delete_hits delete_misses get_hits get_misses evictions incr_hits incr_misses mem_used misses ops );
open INPUT, "<$buckets_file";
while ( <INPUT> ) {
	chomp $_;
	push ( @buckets, $_ );  
}
foreach my $bucket (@buckets) {
	my $json_file = "/var/lib/ops-collectd-couchbase/data/$bucket.json";
	{	
		local $/;
  		open my $fh, "<", "$json_file";
  		$json = <$fh>;
  		close $fh;
	}	
	my $data = decode_json($json);
	my @timestamp = @{$data->{op}->{samples}->{timestamp}};
	my $count = scalar @{$data->{op}->{samples}->{hit_ratio}};
	foreach my $timestamp(@timestamp) {
		substr($timestamp, -3) = ''; 
	}	
	foreach my $key (@keys) {
		for (my $i = 0; $i<$count; $i++ ){
			print "PUTVAL $host/couchbase/gauge-$bucket\_$key $timestamp[$i]:${$data->{op}->{samples}->{$key}}[$i]"."\n";
		}
	}	
}
sleep 50;
}
