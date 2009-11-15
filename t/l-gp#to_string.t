use 5.010000;
use utf8;
use Modern::Perl;
use WebService::EastCoJp::Dictionary::GetDicItemParameter;

use Test::More tests => 4;

my $p = WebService::EastCoJp::Dictionary::GetDicItemParameter->new( );
my $string;

$string = eval { $p->to_string };
isnt( $@, "", "Die if has undef vlaue." );

$p->dic( "EJdict" );
$string = eval { $p->to_string };
isnt( $@, "", "Die if has undef vlaue." );

$p->item( "000000" );
$string = eval { $p->to_string };
is( $@, "", "Did not die if all atribute are valid." );
my $wish = "Dic=EJdict&Item=000000&Loc=&Prof=XHTML";
is( $string, $wish, "Returns valid parameter string." );

