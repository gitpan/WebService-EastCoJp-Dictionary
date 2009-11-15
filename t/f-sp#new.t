use 5.010000;
use utf8;
use Modern::Perl;
use WebService::EastCoJp::Dictionary::SearchDicItemParameter;

use Test::More tests => 2;

my $class = "WebService::EastCoJp::Dictionary::SearchDicItemParameter";

my $p = new_ok( $class );
$p    = new_ok( $class => [ dic => "EJdict", word => "English" ] );

