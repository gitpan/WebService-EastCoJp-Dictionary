package WebService::EastCoJp::Dictionary::SearchDicItemParameter;

use 5.010000;
use utf8;
use Modern::Perl;

use Moose;
use WebService::EastCoJp::Dictionary::ParameterConstraints;

has dic => (
    is      => "rw",
    isa     => "RequestParameter::Dic",
);
has word => (
    is      => "rw",
    isa     => "Str",
);
has _word => (
    is      => "rw",
    isa     => "Str",
);
has scope => (
    is      => "rw",
    isa     => "RequestParameter::Scope",
    default => "HEADWORD",
);
has match => (
    is      => "rw",
    isa     => "RequestParameter::Match",
    default => "STARTWITH",
);
has merge => (
    is      => "rw",
    isa     => "RequestParameter::Merge",
    default => "AND",
);
has prof => (
    is      => "rw",
    isa     => "RequestParameter::Prof",
    default => "XHTML",
);
has page_size => (
    is      => "rw",
    isa     => "Int",
    default => "1",
);
has page_index => (
    is      => "rw",
    isa     => "Int",
    default => "0",
);

__PACKAGE__->meta->make_immutable;

no Moose;

use URI::Escape qw( uri_escape uri_escape_utf8 );

our $VERSION = '0.02';

sub to_string {
    my $self = shift;
    my @attributes = qw( dic word scope match merge prof page_size page_index );

    die "All parameter required."
        if grep { ( ! defined $_ ) or ( $_ eq "" ) }
           map  { $self->$_ }
           @attributes;

    my $word = $self->word;
    $self->_word(
        utf8::is_utf8( $word ) ? uri_escape_utf8( $word ) : uri_escape( $word )
    );

    my @parameters;

    MAP_FOR_REQUEST:
    foreach my $attribute ( @attributes ) {
        my $parameter = $attribute;
        my $method    = $attribute;

        # Rename parameter.
        if ( $parameter eq "word" ) {
            ( $parameter, $method ) = ( "Word", "_word" );
        }
        else {
            $parameter = join( "", map { ucfirst $_ } split "_", $parameter );
        }

        push @parameters, join( "=", ( $parameter, $self->$method ) );
    }

    return join( "&", @parameters );
}

1;
__END__
=head1 NAME

WebService::EastCoJp::Dictionary::SearchDicItemParameter - Make HTTP request parameter for EAST.co.jp

=head1 SYNOPSIS

  use WebService::EastCoJp::Dictionary::SearchDicItemParameter;
  my $p = WebService::EastCoJp::Dictionary::SearchDicItemParameter->new(
      dic  => "EJdict",
      word => "dic",
  );
  say $p->to_string;

=head1 DESCRIPTION

This module is used to make HTTP request parameter.
The parameter is for EAST.co.jp.

This module is used with WebService::EastCoJp::Dictionary.

=head1 ATTRIBUTES

All attribute:

  - dic
  - word
  - scope
  - match
  - merge
  - prof
  - page_size
  - page_index

=ober

=item dic

This attribute is called Dic in EAST.co.jp.

This attribute has constraint of WebService::EastCoJp::Dictionary::ParameterConstraints's
RequestParameter::Dic.

=item word

This attribute is called Word in EAST.co.jp.

This attribute specifies the word that will be translated.

This will encode when call to_string method.
The encode is return value of URI::Escape::uri_encode.

=item scope

This attribute is called Scope in EAST.co.jp.

This attribute specifies a space.
The space is subject or anywhere.

This attribute has constraint of WebService::EastCoJp::Dictionary::ParameterConstraints's
RequestParameter::Scope.

=item match

This attribute is called Match in EAST.co.jp.

This attribute specifies position to which position of the word
the character is corresponding.

This attribute has constraint of WebService::EastCoJp::Dictionary::ParameterConstraints's
RequestParameter::Match.

=item merge

This attribute is called Merge in EAST.co.jp.

This attribute specifies how the query is joined.

This attribute has constraint of WebService::EastCoJp::Dictionary::ParameterConstraints's
RequestParameter::Merge.

=item prof

This attribute is called Prof in EAST.co.jp.

This attribute specifies format of contents.

It is XHTML usually.

This attribute has constraint of WebService::EastCoJp::Dictionary::ParameterConstraints's
RequestParameter::Prof.

=item page_size

This attribute is called PageSize in EAST.co.jp.

This attribute specifies the size of result set.

=item page_index

This attribute is called PageIndex in EAST.co.jp.

This attribute specifies the start index
that is returned value of search request.
It is zero usually.

=back

=head1 METHODS

=over

=item to_string

This method returns a string that for HTTP request.
This method will die when some attributes are undef or empty string.
The attributes are dic and word.

=back

=head1 SEE ALSO

WebService::EastCoJp::Dictionary
WebService::EastCoJp::Dictionary::ParameterConstraints
WebService::EastCoJp::Dictionary::GetDicItemParameter

=head1 AUTHOR

Kuniyoshi Kouji, E<lt>kuniyoshi@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Kuniyoshi Kouji

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut

