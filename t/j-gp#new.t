use 5.010000;
use utf8;
use Modern::Perl;
use WebService::EastCoJp::Dictionary::GetDicItemParameter;

use Test::More tests => 2;

my $class = "WebService::EastCoJp::Dictionary::GetDicItemParameter";

my $p = new_ok( $class );
$p    = new_ok( $class => [ dic => "EdictJE", item => "000000" ] );

