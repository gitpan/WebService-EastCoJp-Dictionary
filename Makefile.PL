use 5.010000;
use ExtUtils::MakeMaker;


WriteMakefile(
    NAME              => 'WebService::EastCoJp::Dictionary',
    VERSION_FROM      => 'lib/WebService/EastCoJp/Dictionary.pm',
    PREREQ_PM         => {
        "Modern::Perl"     => 0,
        "Moose"            => 0,
        "Readonly"         => "1.03",
        "URI::Escape"      => 0,
        "XML::XPath"       => "1.13",
        "Test::LongString" => "0.11",
    },
    LICENSE           => 'perl',
    ABSTRACT_FROM     => 'lib/WebService/EastCoJp/Dictionary.pm',
    AUTHOR            => 'Kuniyoshi Kouji <kuniyoshi@cpan.org>',
);

