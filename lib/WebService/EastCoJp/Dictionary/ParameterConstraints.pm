package WebService::EastCoJp::Dictionary::ParameterConstraints;

use 5.010000;
use utf8;
use Modern::Perl;

use Moose::Util::TypeConstraints;

subtype "RequestParameter::Dic"
    => as "Str"
    => where {
        my $dic = $_;
        1 == grep { $dic eq $_ } qw( EJdict EdictJE wpedia );
    }
    => message { "This parameter must be EJdict or EdictJE or wpedia." }
    ;
subtype "RequestParameter::Scope"
    => as "Str"
    => where {
        my $scope = $_;
        1 == grep { $scope eq $_ } qw( HEADWORD ANYWHERE );
    }
    => message { "This parameter must be HEADWORD or ANYWHERE." }
    ;
subtype "RequestParameter::Match"
    => as "Str"
    => where {
        my $match = $_;
        1 == grep { $match eq $_ } qw( STARTWITH ENDWITH CONTAIN EXACT );
    }
    => message { "This parameter must be STARTWITH or ENDWITH or CONTAIN or EXACT." }
    ;
subtype "RequestParameter::Merge"
    => as "Str"
    => where {
        my $merge = $_;
        1 == grep { $merge eq $_ } qw( AND OR );
    }
    => message { "This parameter must be AND or OR." }
    ;
subtype "RequestParameter::Prof"
    => as "Str"
    => where { $_ eq "XHTML" }
    => message { "This parameter must be XHTML." }
    ;

subtype "RequestParameter::Item"
    => as "Str"
    => where { $_ =~ m{\A \d{4,7} \z}msx }
    => message { "This parameter must be \\d{4,7}." }
    ;
subtype "RequestParameter::Loc"
    => as "Str"
    => where { $_ eq "" }
    => message { "This parameter must be empty string." }
    ;

subtype "RequestParameter::Search"
    => as "Object"
    => where {
        eval { $_->isa( "WebService::EastCoJp::Dictionary::SearchDicItemParameter" ) };
        $@ ? 0 : 1;
    }
    => message { "This parameter must isa SearchDicItemParameter." }
    ;
subtype "RequestParameter::Get"
    => as "Object"
    => where {
        eval { $_->isa( "WebService::EastCoJp::Dictionary::GetDicItemParameter" ) };
        $@ ? 0 : 1;
    }
    => message { "This parameter must isa GetDicItemParameter." }
    ;

no Moose::Util::TypeConstraints;

our $VERSION = '0.01';

1;
__END__
=head1 NAME

WebService::EastCoJp::Dictionary::ParameterConstraints - Constraints for EAST.co.jp's parameter.

=head1 SYNOPSIS

  use Moose;
  use WebService::EastCoJp::Dictionary::ParameterConstraints;
  has dic => (
      is  => "rw",
      isa => "RequestParameter::Dic",
  );

=head1 DESCRIPTION

This module is used to for following modules.

  - WebService::EastCoJp::Dictionary
  - WebService::EastCoJp::Dictionary::SearchDicItemParameter
  - WebService::EastCoJp::Dictionary::GetDicItemParameter

=head1 CONSTRAINTS

All constraint:

  - RequestParameter::Dic
  - RequestParameter::Scope
  - RequestParameter::Match
  - RequestParameter::Merge
  - RequestParameter::Prof
  - RequestParameter::Item
  - RequestParameter::Loc
  - RequestParameter::Search
  - RequestParameter::Get

=over

=item RequestParameter::Dic

This constraint restrict to "EJdict" or "EdictJE" or "wpedia" the Dic attribute.

=item RequestParameter::Scope

This constraint restrict to "HEADWORD" or "ANYWHERE" the Scope attribute.

=item RequestParameter::Match

This constraint restrict to "STARTWITH" or "ENDWITH" or "CONTAIN" or "EXACT" the Match attribute.

=item RequestParameter::Merge

This constraint restrict to "AND" or "OR" the Merge attribute.

=item RequestParameter::Prof

This constraint restrict to "XHTML" the Prof attribute.

=item RequestParameter::Item

This constraint restrict to numeric string the Item attribute.

=item RequestParameter::Loc

This constraint restrict to empty string the Loc attribute.

=item RequestParameter::Search

This constraint restrict to SearchDicItemParameter the search attribute.

=item RequestParameter::Get

This constraint restrict to GetDicItemParameter the search attribute.

=back

=head1 SEE ALSO

WebService::EastCoJp::Dictionary
WebService::EastCoJp::Dictionary::SearchDicItemParameter
WebService::EastCoJp::Dictionary::GetDicItemParameter

=head1 AUTHOR

Kuniyoshi Kouji, E<lt>kuniyoshi@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Kuniyoshi Kouji

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut

