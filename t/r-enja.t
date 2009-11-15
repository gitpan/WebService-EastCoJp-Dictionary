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

my $result = $d->enja( "English" );
my $wish   = "English\t〈Ｕ〉《通例冠詞をつけないで》『英語』	《ｔｈｅ～》《集合的に》《複数扱い》『イギリス人』，イングランド人，英国民［全体］	英語の先生	『イギリスの』，英国の，イングランドの；『イギリス人の』，英国人の	『英語の』";
is( $result, $wish, "Can English." );

my $filename = "t/translated_enja.txt";
open my $FH, "<:utf8", $filename
    or die "Could not open a file:[$filename].\n[$!]";
my @wishes = map { chomp; $_ =~ s{[{]TAB[}]}{\t}gmsx; $_ }
             <$FH>;
close $FH
    or die "Coudl not close a file:[$filename].\n[$!]";

$d->parameter->match( "STARTWITH" );
$d->parameter->page_size( 3 );
my @results = $d->enja( "loc" );
is_deeply( \@results, \@wishes, "Can dictionary." );

