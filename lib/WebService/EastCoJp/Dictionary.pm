package WebService::EastCoJp::Dictionary;

use 5.010000;
use utf8;
use Modern::Perl;
use Moose;
use WebService::EastCoJp::Dictionary::ParameterConstraints;
use WebService::EastCoJp::Dictionary::SearchDicItemParameter;
use WebService::EastCoJp::Dictionary::GetDicItemParameter;

has parameter => (
    is      => "rw",
    isa     => "RequestParameter::Search",
    default => sub { WebService::EastCoJp::Dictionary::SearchDicItemParameter->new( ) },
);

__PACKAGE__->meta->make_immutable;

no Moose;

use Carp;
use Readonly;
use LWP::UserAgent;
use XML::XPath;

our $VERSION = '0.02';

Readonly my %URL => (
    search_item => "http://btonic.est.co.jp/NetDic/NetDicV09.asmx/SearchDicItemLite",
    get_item    => "http://btonic.est.co.jp/NetDic/NetDicV09.asmx/GetDicItemLite",
);

sub can_reach_to_the_server {
    my $self    = shift;
    my $ua      = LWP::UserAgent->new( );
    my $message = "500 Internal Server Error";

    CAN_NOT_REACH:
    foreach my $url ( values %URL ) {
        my $res = $ua->get( $url );

        return
            unless lc $res->status_line eq lc $message;
    }

    return 1;
}

sub _search_dic_item_lite {
    my $self = shift;

    my $p   = $self->parameter;
    my $url = join( "?", ( $URL{search_item}, $p->to_string ) );
    my $ua  = LWP::UserAgent->new( );

    my $res = $ua->get( $url );
    die "Could not search item.\n[", $res->status_line, "]"
        if $res->is_error;

    my $content = $res->decoded_content;

    # The content has CRLF, but I want LF.
    $content =~ tr{\x0d}{}d;
#say "### Searched XML ", "#" x 62, "\n", $content, "\n", "#" x 80;

    # Die if no item.
    my $xpath = XML::XPath->new( xml => $content );
    my( $hit_node ) = $xpath->find( "//TotalHitCount" )->get_nodelist;
    die $self->parameter->word, " is not registered in ", $self->parameter->dic, ".\n"
        if $hit_node->string_value eq "0";

    return $content;
}

sub _get_dic_item_lite {
    my $self = shift;

    die "An argument required."
        if @_ != 1;

    my $p = shift;
    my $p_isa_get_parameter
        = eval { $p->isa( "WebService::EastCoJp::Dictionary::GetDicItemParameter" ) };

    die "An argument must isa GetDicItemParameter."
        unless $p_isa_get_parameter;

    my $url = join( "?", ( $URL{get_item}, $p->to_string ) );
    my $ua  = LWP::UserAgent->new( );

    my $res = $ua->get( $url );
    die "Could not get item.\n[", $res->status_line, "]"
        if $res->is_error;

    my $content = $res->decoded_content;

    # The content has CRLF, but I want LF.
    $content =~ tr{\x0d}{}d;

    return $content;
}

sub _die_if_xml_has_error {
    my $self = shift;
    my $xml  = shift;

    my $xpath    = XML::XPath->new( xml => $xml );
    my( $error ) = $xpath->find( "//ErrorMessage" )->get_nodelist;
    my $message  = $error->toString;
#say "### ", $error->toString;

    die "Received XML has error[$message]."
        if $message ne "<ErrorMessage />";

    return;
}

sub _search_and_get_dic_item {
    my $self = shift;

    croak "Argument does not has ref."
        if @_ == 1 and ref $_[0] eq ref +{ };
    croak "The number of argument is odd.  Argument can not be treated hash."
        if @_ % 2;

    my %parameter = @_ != 1 ? @_ : %{ $_[0] };
    my $p         = $self->parameter;
    # TODO: Change this copy to shallow copy.
    # This will change default parameter without user's Agreement.
    # It does not care now.  Because this changes arguments only
    # dic and word.  Be carefull when this changes other arguemtns.

    SET_PARAMETER:
    foreach my $key ( sort keys %parameter ) {
        $p->$key( $parameter{ $key } );
    }

    my $xml   = $self->_search_dic_item_lite;
    my $xpath = XML::XPath->new( xml => $xml );
#say "### xml ", "#" x 72;
#say $xml;
#say "#" x 80;

    # Did fail?
    $self->_die_if_xml_has_error( $xml );

    # Set with narrow scope.
    my %translation;
    {
        my @items  = map { $_->string_value }
                     $xpath->find( "//DicItemTitle/ItemID" )->get_nodelist;
        my @titles = map { $_->string_value }
                     $xpath->find( "//DicItemTitle/Title/span" )->get_nodelist;
        die "Could not parse XML."
            unless @items == @titles;

        %translation = map { ( $titles[$_], $items[$_] ) }
                       ( 0 .. $#items );
    }

    my $get_p = WebService::EastCoJp::Dictionary::GetDicItemParameter->new( );
    $get_p->dic( $p->dic );

    my @xmls;

    GET_XMLS:
    foreach my $title ( sort keys %translation ) {
        my $item = $translation{ $title };
        $get_p->item( $item );

        my $xml = $self->_get_dic_item_lite( $get_p );
#say "### xml ", "#" x 72;
#say $xml;
#say "#" x 80;

        # Did fail?
        $self->_die_if_xml_has_error( $xml );

        if ( ! wantarray ) {
            return $xml;
        }
        else {
            push @xmls, $xml;
        }
    }

    return @xmls;
}

sub enja {
    my $self  = shift;
    my @words = @_;
    croak "Argument required."
        unless @words;

    $self->parameter->dic( "EJdict" );
    $self->parameter->word( join( " ", @words ) );
    # TODO: This changes global parameter, but it does not notice to user.
    # Consider this when another parameter will be changed.

    my @xmls = wantarray ? $self->_search_and_get_dic_item
                         : ( scalar $self->_search_and_get_dic_item )
                         ;
#print map { "#" x 80 . "\n" . $_ . "\n" . "#" x 80 . "\n" } @xmls;

    my %translation;

    PARSE_TRANSLATED_XML:
    foreach my $xml ( @xmls ) {
        my $xpath = XML::XPath->new( xml => $xml );

        my( $head_node ) = $xpath->find( "//Head/div/span" )->get_nodelist;
        my( $body_node ) = $xpath->find( "//Body/div/div" )->get_nodelist;

        $translation{ $head_node->string_value }
            = $body_node->string_value;
    }

    if ( ! wantarray ) {
        my( $content ) = map { join( "\t", ( $_, $translation{ $_ } ) ) }
                         sort keys %translation
                         ;
        return $content;
    }
    else {
        return map { join( "\t", ( $_, $translation{ $_ } ) ) }
               sort keys %translation
               ;
    }
}

sub jaen {
    my $self  = shift;
    my @words = @_;
    croak "Argument required."
        unless @words;

    $self->parameter->dic( "EdictJE" );
    $self->parameter->word( join( " ", @words ) );
    # TODO: This changes global parameter, but it does not notice to user.
    # Consider this when another parameter will be changed.

    my @xmls = wantarray ? $self->_search_and_get_dic_item
                         : ( scalar $self->_search_and_get_dic_item )
                         ;
#print map { "#" x 80 . "\n" . $_ . "\n" . "#" x 80 . "\n" } @xmls;

    my %translation;

    PARSE_TRANSLATED_XML:
    foreach my $xml ( @xmls ) {
        my $xpath = XML::XPath->new( xml => $xml );

        my( $head_node ) = $xpath->find( "//Head/div/span" )->get_nodelist;
        my @body_nodes   = $xpath->find( "//Body/div/div/div" )->get_nodelist;

        my $heading = $head_node->string_value;
        $heading = join( "", split "\n", $heading );
        $heading = join( "ー", split "[\\s]+", $heading );

        my @bodies = grep { $_ !~ m{\A \s* \z}msx }
                     map  { $_->string_value }
                     @body_nodes
                     ;
        my $body = join( "\t", @bodies );

        $translation{ $heading } = $body;
    }

    if ( ! wantarray ) {
        my( $content ) = map { join( "\t", ( $_, $translation{ $_ } ) ) }
                         sort keys %translation
                         ;
        return $content;
    }
    else {
        return map { join( "\t", ( $_, $translation{ $_ } ) ) }
               sort keys %translation
               ;
    }
}

sub jaja {
    my $self  = shift;
    my @words = @_;
    croak "Argument required."
        unless @words;

    $self->parameter->dic( "wpedia" );
    $self->parameter->word( join( " ", @words ) );
    # TODO: This changes global parameter, but it does not notice to user.
    # Consider this when another parameter will be changed.

    my @xmls = wantarray ? $self->_search_and_get_dic_item
                         : ( scalar $self->_search_and_get_dic_item )
                         ;
#print map { "#" x 80 . "\n" . $_ . "\n" . "#" x 80 . "\n" } @xmls;

    my %translation;

    PARSE_TRANSLATED_XML:
    foreach my $xml ( @xmls ) {
        my $xpath = XML::XPath->new( xml => $xml );

        my( $head_node ) = $xpath->find( "//Head/div/span" )->get_nodelist;
        my( $body_node ) = $xpath->find( "//Body/div/div" )->get_nodelist;

        $translation{ $head_node->string_value }
            = $body_node->string_value;
    }

    if ( ! wantarray ) {
        my( $content ) = map { join( "\t", ( $_, $translation{ $_ } ) ) }
                         sort keys %translation
                         ;
        return $content;
    }
    else {
        return map { join( "\t", ( $_, $translation{ $_ } ) ) }
               sort keys %translation
               ;
    }
}

1;
__END__
=encoding utf-8

=head1 NAME

WebService::EastCoJp::Dictionary - An interface for REST service of EAST.co.jp

=head1 SYNOPSIS

  use WebService::EastCoJp::Dictionary;

  die "Could not reach to the server."
      unless WebService::EastCoJp::Dictionary::can_reach_to_the_server( );

  my $d = WebService::EastCoJp::Dictionary->new( );
  $d->parameter->match( "EXACT" );

  say $d->enja( "English" );
  say $d->jaen( "日本語" );

  my( $title, @contents ) = split "\t", $d->enja( "Japanese" );

  $d->parameter->match( "STARTWITH" );
  $d->parameter->page_size( 3 );

  SAY_TRANSLATION:
  foreach my $translation ( $d->enja( "loc" ) ) {
      my( $title, @contents ) = split "\t", $translation;

      my $head_message = "### $title ";
      my $length = length( $head_message )
                   + do { require bytes; bytes::length( $head_message ) };
      $length /= 2;
      say $head_message, "#" x ( 80 - $length );
      print map { "[ $_ ]\n" } @contents;
  }

=head1 DESCRIPTION

This module is an interface for REST service of EAST.co.jp.
The server offers the dictionary retrieval.

The server has URL of "http://www.btonic.com/ws/index.html".

The server has some services, which are:

  - translate English into Japanese
  - translate Japanese into English

=head1 ATTRIBUTES

This class has an attribute.
The attribute isa WebService::EastCoJp::Dictionary::SearchDicItemParameter.

=head1 METHODS

Methods are:

  - can_reach_to_the_server: test it
  - enja: for translate English into Japanese
  - jaen: for translate Japanese into English

Following methods are for developer:

  - _search_dic_item_lite
  - _get_dic_item_lite

=over

=item can_reach_to_the_server

This method tests that this environment can reach to
the server of EAST.co.jp.

=item enja

This method returns the translation of argument.
This method will die when it fails in translation.

The returned value is Japanese.

=item jaen

This method returns the translation of argument.
This method will die when fail translation.

The returned value is English.

=item jaja

This method has been reserved for the future.

This will describe a argument.

=back

=head1 SEE ALSO

WebService::EastCoJp::Dictionary::SearchDicItemParameter
WebService::EastCoJp::Dictionary::GetDicItemParameter
WebService::EastCoJp::Dictionary::ParameterConstraints

=head1 AUTHOR

Kuniyoshi Kouji, E<lt>kuniyoshi@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Kuniyoshi Kouji

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut

