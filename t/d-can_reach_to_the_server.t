use 5.010000;
use utf8;
use Modern::Perl;
use WebService::EastCoJp::Dictionary;

use Test::More tests => 1;

eval { WebService::EastCoJp::Dictionary::can_reach_to_the_server( ) };
is( $@, "", "Did not die." );

