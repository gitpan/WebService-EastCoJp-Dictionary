use 5.010000;
use utf8;
use Modern::Perl;
use WebService::EastCoJp::Dictionary;

use Test::More tests => 3;
use Test::LongString;

my $d = WebService::EastCoJp::Dictionary->new( );
$d->parameter->dic( "EJdict" );
$d->parameter->word( "eas" );
$d->parameter->page_size( 5 );

my $filename = "t/some_XMLs.xml";
open my $FH, "<:utf8", $filename
    or die "Could not open a file:[$filename].\n[$!]";
my $some_xmls = join( "", <$FH> );
close $FH
    or die "Could not close a file:[$filename].\n[$!]";

my @xmls = $d->_search_and_get_dic_item;
is( @xmls, 5, "Can recognize context." );
is_string( join( "\n", ( @xmls, "" ) ), $some_xmls, "Returns some XML." );

@xmls = scalar $d->_search_and_get_dic_item;
is( @xmls, 1, "Can recognize context." );

