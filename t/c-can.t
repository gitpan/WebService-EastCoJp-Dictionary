use 5.010000;
use utf8;
use Modern::Perl;
use WebService::EastCoJp::Dictionary;

use Test::More tests => 1;

my $class = "WebService::EastCoJp::Dictionary";
my @methods = qw(
    can_reach_to_the_server
    parameter
    _search_dic_item_lite  _get_dic_item_lite
    enja  jaen  jaja
);

can_ok( $class, @methods );

