use 5.010000;
use utf8;
use Modern::Perl;
use WebService::EastCoJp::Dictionary;

use Test::More tests => 2;

my $d = WebService::EastCoJp::Dictionary->new( );

my $filename = "t/has_no_error.xml";

open my $FH, "<:utf8", $filename
    or die "Could not open a file:[$filename].\n[$!]";
my $xml = join( "", <$FH> );
close $FH
    or die "Could not close a file:[$filename].\n[$!]";

my $did_not_die = eval { $d->_die_if_xml_has_error( $xml ) };
is( $@, "", "No error did not die." );
is( $did_not_die, undef, "No error did not die." );

