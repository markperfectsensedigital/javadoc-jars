#!/usr/bin/perl


use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request;
my $ua = LWP::UserAgent->new;
#my $req = HTTP::Request->new( HEAD => 'http://docs.brightspot.com');
my $req = HTTP::Request->new( HEAD => 'https://artifactory.psdops.com/psddev-releases/com/psddev/dari/3.2.2466-9f28f3/dari-3.2.2466-9f28f3-javadoc.jar');
my $response = $ua->request($req);
print $response->code . "\n";

=pod
use strict;

use warnings;
use LWP::UserAgent;
use HTTP::Request;

		my $ua = LWP::UserAgent->new;
		my $u = 'http://docs.brightspot.com';
		#my $u = 'https://artifactory.psdops.com/psddev-releases/com/psddev/dari/3.2.2466-9f28f3/dari-3.2.2466-9f28f3-javadoc.jar';
		my $req = HTTP::Request->new( HEAD => $u);
		my $response = $ua->request($req);
		print "URL $u: Response " . $response->code . "\n";


exit;
open (my $config_file,"/Users/mlautman/Documents/docs/conf.py") || die "Cannot open config.py, $!\n";
while (<$config_file>) {
	if ($_ =~ m/https:\/\/artifactory.psdops.com\/psddev-releases\/com\/psddev\/.*javadoc\.jar/) {
		my $ua = LWP::UserAgent->new;
		my $req = HTTP::Request->new( HEAD => $&);
		my $response = $ua->request($req);
		print "URL $&: Response " . $response->code . "\n";
	}
}

close ($config_file);
=cut
