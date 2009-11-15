use 5.010000;
use utf8;
use Modern::Perl;
use WebService::EastCoJp::Dictionary::GetDicItemParameter;

use Test::More tests => 1;

my $p = WebService::EastCoJp::Dictionary::GetDicItemParameter->new( );
my @methods = qw(
    dic  item  loc  prof
    to_string
);

can_ok( $p, @methods );

