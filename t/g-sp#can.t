use 5.010000;
use utf8;
use Modern::Perl;
use WebService::EastCoJp::Dictionary::SearchDicItemParameter;

use Test::More tests => 1;

my $p = WebService::EastCoJp::Dictionary::SearchDicItemParameter->new( );
my @methods = qw(
    dic  word  scope  match  merge  prof  page_size  page_index
    to_string
);

can_ok( $p, @methods );

