use 5.010000;
use utf8;
use Modern::Perl;
use WebService::EastCoJp::Dictionary;

use Test::More tests => 4;

my $d = WebService::EastCoJp::Dictionary->new( );

my $isa = eval {
    $d->parameter->isa( "WebService::EastCoJp::Dictionary::SearchDicItemParameter" )
};
is( $isa, 1, "Parameter isa WebService::EastCoJp::Dictionary::SearchDicItemParameter" );

my $word = $d->parameter->word;
is( $word, undef, "Not set yet." );

$word = "English";
$d->parameter->word( $word );
my $new_word = $d->parameter->word;
is( $new_word, $word, "Can set parameter." );

$word = "日本語";
$d->parameter->word( $word );
$new_word = $d->parameter->word;
is( $new_word, $word, "Can set parameter." );

