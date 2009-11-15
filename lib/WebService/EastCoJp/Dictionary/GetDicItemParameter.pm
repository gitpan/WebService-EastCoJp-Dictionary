package WebService::EastCoJp::Dictionary::GetDicItemParameter;

use 5.010000;
use utf8;
use Modern::Perl;

use Moose;
use WebService::EastCoJp::Dictionary::ParameterConstraints;

has dic => (
    is      => "rw",
    isa     => "RequestParameter::Dic",
    default => undef,
);
has item => (
    is      => "rw",
    isa     => "RequestParameter::Item",
    default => undef,
);
has loc => (
    is      => "ro",
    isa     => "RequestParameter::Loc",
    default => "",
);
has prof => (
    is      => "ro",
    isa     => "RequestParameter::Prof",
    default => "XHTML",
);

__PACKAGE__->meta->make_immutable;

no Moose;

our $VERSION = '0.01';

sub to_string {
    my $self = shift;
    my @attributes = qw( dic item loc prof );

    die "dic is required."
        unless $self->dic;
    die "item is required."
        unless $self->item;

    my @parameters;

    foreach my $attribute ( @attributes ) {
        my $parameter = ucfirst $attribute;

        push @parameters, join( "=", ( $parameter, $self->$attribute ) );
    }

    return join( "&", @parameters );
}

1;
__END__
=head1 NAME

WebService::EastCoJp::Dictionary::GetDicItemParameter - Make HTTP request parameter for EAST.co.jp

=head1 SYNOPSIS

  use WebService::EastCoJp::Dictionary::GetDicItemParameter;
  my $p = WebService::EastCoJp::Dictionary::GetDicItemParameter->new(
      dic  => "EJdict",
      item => "000000",
  );
  say $p->to_string;

=head1 DESCRIPTION

This module is used to make HTTP request parameter.
The parameter is for EAST.co.jp.

This module is used wish WebService::EastCoJp::Dictionary.

=head1 ATTRIBUTES

All attribute:

  - dic
  - item
  - loc
  - prof

=over

=item dic

This attribute is called Dic in EAST.co.jp.

This attribute has constraint of WebService::EastCoJp::Dictionary::ParameterConstraints's
RequestParameter::Dic.

=item item

This attribute is called Item in EAST.co.jp.

The value of attribute is the result of the searching.
The searching request must be ealier than this attribute is set.

This attribute has constraint of WebService::EastCoJp::Dictionary::ParameterConstraints's
RequestParameter::Item.

=item loc

This attribute is called Loc in EAST.co.jp.

This attribute offers special some behavior in some dic.
I do'nt know the value of dic.
The value might be offered to the business partner of EAST.co.jp.

This attribute has constraint of WebService::EastCoJp::Dictionary::ParameterConstraints's
RequestParameter::Loc.

=item prof

This attribute is called Prof in EAST.co.jp.

This attribute specifies format of contents.

It is XHTML usually.

This attribute has constraint of WebService::EastCoJp::Dictionary::ParameterConstraints's
RequestParameter::Prof.

=back

=head1 METHODS

=over

=item to_string

This method returns a string that for HTTP request.
This method will die when some attributes are undef or empty string.
The attributes are dic and item.

=back

=head1 SEE ALSO

WebService::EastCoJp::Dictionary
WebService::EastCoJp::Dictionary::ParameterConstraints
WebService::EastCoJp::Dictionary::SearchDicItemParameter

=head1 AUTHOR

Kuniyoshi Kouji, E<lt>kuniyoshi@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Kuniyoshi Kouji

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut

