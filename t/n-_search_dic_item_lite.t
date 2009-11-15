use 5.010000;
use utf8;
use Modern::Perl;
use WebService::EastCoJp::Dictionary;
use WebService::EastCoJp::Dictionary::SearchDicItemParameter;
use WebService::EastCoJp::Dictionary::GetDicItemParameter;

use Test::More;
use Test::LongString;

if ( WebService::EastCoJp::Dictionary::can_reach_to_the_server( ) ) {
    plan tests => 4;
}
else {
    plan skip_all => "This environment can not reach to the server.";
}

my $xml;
my $d = WebService::EastCoJp::Dictionary->new( );

$xml = eval { $d->_search_dic_item_lite };
like( $@, qr/All parameter required/i, "Can not call to_string method." );

chomp( my $xml_wish = <<'WISH' );
<?xml version="1.0" encoding="utf-8"?>
<SearchDicItemResult xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://btonic.est.co.jp/NetDic/NetDicV09">
  <ErrorMessage />
  <TotalHitCount>11</TotalHitCount>
  <ItemCount>11</ItemCount>
  <TitleList>
    <DicItemTitle>
      <ItemID>011348</ItemID>
      <LocID />
      <Title>
        <span class="NetDicTitle" xmlns="">dict.</span>
      </Title>
    </DicItemTitle>
    <DicItemTitle>
      <ItemID>011349</ItemID>
      <LocID />
      <Title>
        <span class="NetDicTitle" xmlns="">dicta</span>
      </Title>
    </DicItemTitle>
    <DicItemTitle>
      <ItemID>011350</ItemID>
      <LocID />
      <Title>
        <span class="NetDicTitle" xmlns="">Dictaphone</span>
      </Title>
    </DicItemTitle>
    <DicItemTitle>
      <ItemID>011351</ItemID>
      <LocID />
      <Title>
        <span class="NetDicTitle" xmlns="">dictate</span>
      </Title>
    </DicItemTitle>
    <DicItemTitle>
      <ItemID>011352</ItemID>
      <LocID />
      <Title>
        <span class="NetDicTitle" xmlns="">dictation</span>
      </Title>
    </DicItemTitle>
    <DicItemTitle>
      <ItemID>011353</ItemID>
      <LocID />
      <Title>
        <span class="NetDicTitle" xmlns="">dictator</span>
      </Title>
    </DicItemTitle>
    <DicItemTitle>
      <ItemID>011354</ItemID>
      <LocID />
      <Title>
        <span class="NetDicTitle" xmlns="">dictatorial</span>
      </Title>
    </DicItemTitle>
    <DicItemTitle>
      <ItemID>011355</ItemID>
      <LocID />
      <Title>
        <span class="NetDicTitle" xmlns="">dictatorship</span>
      </Title>
    </DicItemTitle>
    <DicItemTitle>
      <ItemID>011356</ItemID>
      <LocID />
      <Title>
        <span class="NetDicTitle" xmlns="">diction</span>
      </Title>
    </DicItemTitle>
    <DicItemTitle>
      <ItemID>011357</ItemID>
      <LocID />
      <Title>
        <span class="NetDicTitle" xmlns="">dictionary</span>
      </Title>
    </DicItemTitle>
    <DicItemTitle>
      <ItemID>011358</ItemID>
      <LocID />
      <Title>
        <span class="NetDicTitle" xmlns="">dictum</span>
      </Title>
    </DicItemTitle>
  </TitleList>
</SearchDicItemResult>
WISH

$d->parameter->dic( "EJdict" );
$d->parameter->word( "dict" );
$d->parameter->page_size( 20 );
$xml = eval { $d->_search_dic_item_lite };
is_string( $xml, $xml_wish, "Can if English." );

chomp( $xml_wish = <<'WISH' );
<?xml version="1.0" encoding="utf-8"?>
<SearchDicItemResult xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://btonic.est.co.jp/NetDic/NetDicV09">
  <ErrorMessage />
  <TotalHitCount>2</TotalHitCount>
  <ItemCount>2</ItemCount>
  <TitleList>
    <DicItemTitle>
      <ItemID>096447</ItemID>
      <LocID />
      <Title>
        <span class="NetDicTitle" xmlns="">飛行機</span>
      </Title>
    </DicItemTitle>
    <DicItemTitle>
      <ItemID>096448</ItemID>
      <LocID />
      <Title>
        <span class="NetDicTitle" xmlns="">飛行機雲</span>
      </Title>
    </DicItemTitle>
  </TitleList>
</SearchDicItemResult>
WISH

$d->parameter->dic( "EdictJE" );
$d->parameter->word( "飛行機" );
$d->parameter->page_size( 2 );
$xml = eval { $d->_search_dic_item_lite };
is_string( $xml, $xml_wish, "Can if Japanese." );

$d->parameter->dic( "EJdict" );
$d->parameter->word( "XML" );
$d->parameter->page_size( 2 );
$xml = eval { $d->_search_dic_item_lite };
like( $@, qr/is not registered/i, "Not found." );

