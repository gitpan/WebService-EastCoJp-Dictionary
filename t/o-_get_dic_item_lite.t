use 5.010000;
use utf8;
use Modern::Perl;
use WebService::EastCoJp::Dictionary;
use WebService::EastCoJp::Dictionary::SearchDicItemParameter;
use WebService::EastCoJp::Dictionary::GetDicItemParameter;

use Test::More;
use Test::LongString;

if ( WebService::EastCoJp::Dictionary::can_reach_to_the_server( ) ) {
    plan tests => 5;
}
else {
    plan skip_all => "This environment can not reach to the server.";
}

my $xml;
my $d = WebService::EastCoJp::Dictionary->new( );
my $p = WebService::EastCoJp::Dictionary::GetDicItemParameter->new( );

$xml = eval { $d->_get_dic_item_lite };
like( $@, qr/Argument required/i, "Die if no argument." );

$xml = eval { $d->_get_dic_item_lite( "asdf" ) };
like( $@, qr/must isa GetDicItemParameter/i, "Dif if does not object isa ~." );

$xml = eval { $d->_get_dic_item_lite( $p ) };
like( $@, qr/is required/i, "Can not call to_string method." );

chomp( my $xml_wish = <<'WISH' );
<?xml version="1.0" encoding="utf-8"?>
<GetDicItemResult xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://btonic.est.co.jp/NetDic/NetDicV09">
  <ErrorMessage />
  <Head>
    <div class="NetDicHead" xml:space="preserve" xmlns="">
					<span class="NetDicHeadTitle">dictionary</span>
					
					
				</div>
  </Head>
  <Body>
    <div class="NetDicBody" xml:space="preserve" xmlns="">
					<div>『辞書』，辞典，字引き</div>
				</div>
  </Body>
</GetDicItemResult>
WISH

$p->dic( "EJdict" );
$p->item( "011357" );
$xml = eval { $d->_get_dic_item_lite( $p ) };
is_string( $xml, $xml_wish, "Can if EJdict." );

chomp( $xml_wish = <<'WISH' );
<?xml version="1.0" encoding="utf-8"?>
<GetDicItemResult xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://btonic.est.co.jp/NetDic/NetDicV09">
  <ErrorMessage />
  <Head>
    <div class="NetDicHead" xml:space="preserve" xmlns="">
					<span class="NetDicHeadTitle">飛行機
				［ひこうき］
			</span>
					
					
				</div>
  </Head>
  <Body>
    <div class="NetDicBody" xml:space="preserve" xmlns="">
					<div>
        <div>(n) aeroplane</div>
        <div>airplane</div>
        <div>(P)</div>
        <div>
        </div>
      </div>
				</div>
  </Body>
</GetDicItemResult>
WISH

$p->dic( "EdictJE" );
$p->item( "096447" );
$xml = eval { $d->_get_dic_item_lite( $p ) };
is_string( $xml, $xml_wish, "Can if EdictJE." );

