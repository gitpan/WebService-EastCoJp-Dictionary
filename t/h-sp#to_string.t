use 5.010000;
use utf8;
use Modern::Perl;
use WebService::EastCoJp::Dictionary::SearchDicItemParameter;

use Test::More tests => 4;

my $p = WebService::EastCoJp::Dictionary::SearchDicItemParameter->new( );
my $string;

$string = eval { $p->to_string };
isnt( $@, "", "Die if has undef vlaue." );

$p->dic( "EJdict" );
$string = eval { $p->to_string };
isnt( $@, "", "Die if has undef vlaue." );

$p->word( "English" );
$string = eval { $p->to_string };
is( $@, "", "Did not die if all atribute are valid." );
my $wish = "Dic=EJdict&Word=English&Scope=HEADWORD&Match=STARTWITH&Merge=AND&Prof=XHTML&PageSize=1&PageIndex=0";
is( $string, $wish, "Returns valid parameter string." );

