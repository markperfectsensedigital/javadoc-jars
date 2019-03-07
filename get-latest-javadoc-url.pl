#!/usr/bin/perl

# This script forms the URL required for the extlinks property in
# the Sphinx conf.py. You can see an example of the final output of
# this script at https://github.com/perfectsense/docs/blob/release/4.0/conf.py#L329 .
#
# The script goes to the base URL https://artifactory.psdops.com/psddev-releases/com/psddev/,
# and then examines each of the indexes in the @products array. Each of
# those indexes contains a list of version numbers. We sort the version
# numbers from highest to lowest, and then examine each of the pages
# associated with the version number. If that page has a javadoc.jar file,
# then report the entire link to that file as the one associated with the
# product.


use strict;
use warnings;
use HTTP::Tiny;

my @products = ( 
	'cms-db/',
	'dari-db/',
	'dari-aws/',
	'dari-elasticsearch/',
	'dari-h2/',
	'dari-mysql/',
	'dari-sql/',
	'dari-util/',
	'dari-image/',
	'dari-jclouds/',
	'dari-mail/',
	'dari-storage/',
	'personalization/',
	'timeseries/',
	'google-analytics/',
	'sitemap/'
);
my $base_url = "https://artifactory.psdops.com/psddev-releases/com/psddev/";

print 'extlinks = {';
foreach (@products) {
	#print "Retrieving latest javadoc version for $_\n";
	my $version = get_latest_javadoc($_, $base_url);
	my $product_noslash = $_;
	$product_noslash =~ s/\/$//;
	my $key = "$product_noslash-javadocs";
	print "            '$key': ('$base_url$_$version!%s', None),\n";
	#print "Latest javadoc version for $_ is $base_url$_$version!%s\n\n";
}
print "            }\n";


print "All done\n";


sub get_latest_javadoc {
# Extract the passed product and base URL.
	my $product = shift (@_);
   my $base_url = shift (@_);
# Instantiate an HTTP object for retrieving the contents of a URL.
	my $http= HTTP::Tiny->new;
	my $url = "$base_url$product";
	my $response = $http->get($url);
	if ($response->{success}) {
		#print "   Extracing version numbers for $product...\n";
		my $html = $response->{content};
		my @lines = split("\n",$html);
		my @version_numbers;
		foreach (@lines) {
			# Examing each line of retrieved HTML, if the line starts
			# with <a href="<digit>, then extract the version number.
			if ($_ =~ s/^<a href="\d.*?>(.*)<\/a>.*/$1/) {
				push(@version_numbers,$1);
			}
		}
		#print "   Sorting version numbers for $product...\n";
		my @sorted_version_numbers = reverse(@version_numbers);
		foreach (@sorted_version_numbers) {
			my $version_url = "$url$_";
			#print "   Checking if version $_ has javadoc...\n";
			$response = $http->get($version_url);
			if ($response->{success}) {
				my $version_response = $response->{content};
				if ($version_response =~ m/href="(\S*javadoc\.jar)"/) {
					#print "   The latest javadoc is in version $_, file $_$1, at URL $version_url\n";
					return "$_$1";
					exit;
				}
			} else {
				print "Failed: $response->{status} $response->{reasons}\n";
				exit;
			}
		}
	} else {
		print "Failed: $response->{status} $response->{reasons}\n";
		exit;
	}
}

