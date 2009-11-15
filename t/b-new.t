use 5.010000;
use utf8;
use Modern::Perl;
use WebService::EastCoJp::Dictionary;

use Test::More tests => 1;

my $class = "WebService::EastCoJp::Dictionary";
my $obj   = new_ok( $class );

