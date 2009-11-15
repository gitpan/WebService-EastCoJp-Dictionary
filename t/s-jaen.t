use 5.010000;
use utf8;
use Modern::Perl;
use WebService::EastCoJp::Dictionary;

use Test::More;

if ( WebService::EastCoJp::Dictionary::can_reach_to_the_server( ) ) {
    plan tests => 2;
}
else {
    plan skip_all => "This environment can not reach to the server.";
}

my $d = WebService::EastCoJp::Dictionary->new( );
$d->parameter->match( "EXACT" );

my $result = $d->jaen( "双眸" );
my $wish   = "双眸ー［そうぼう］\t(n) pair of eyes";
is( $result, $wish, "Can Japanese." );

my $filename = "t/translated_jaen.txt";
open my $FH, "<:utf8", $filename
    or die "Could not open a file:[$filename].\n[$!]";
my @wishes = map { chomp; $_ =~ s{[{]TAB[}]}{\t}gmsx; $_ }
             <$FH>;
close $FH
    or die "Coudl not close a file:[$filename].\n[$!]";

$d->parameter->match( "STARTWITH" );
$d->parameter->page_size( 3 );
my @results = $d->jaen( "壁" );
is_deeply( \@results, \@wishes, "Can dictionary." );

