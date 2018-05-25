#!/usr/bin/env perl

use strict;
use warnings;
use XML::LibXML; # provides: XML::LibXML::Schema
use XML::Twig;
use Try::Tiny;
use Data::Dumper; # dumper

my $xml_file = $ARGV[0];
my $xsd_file = $ARGV[1];

# open FIN, '<', $xml_file
#     or die "Unable to open file: $xml_file - $!";
# my $xml = join '', <FIN>;
# close FIN;

my $xml = XML::LibXML->load_xml(
    location => $xml_file,
);

if (validate_xml_against_xsd($xml, $xsd_file)) {
    print "XML is adhering to XSD\n";
} else {
    print "XML is NOT adhering to XSD, please see the error\n";
}

print STDERR "Done...\n";

exit 0;

sub validate_xml_against_xsd {
    my ($xml, $xsd_file) = @_;

    my $schema = XML::LibXML::Schema->new(location => $xsd_file);

    try {
        local($SIG{__DIE__});

        $schema->validate( $xml )
    } catch {
        my $error = ref $_ ? $_->message : $_;

        print STDERR Dumper {
            epp_error_message => 'XSD Validation failed '. $error,
            epp_status_code   => 2001,
            failed_xml => toStringPretty($xml),
        };

        die;
    };

    return 1;
}

sub toStringPretty {
    my $xml = shift;

    my $parser = XML::Twig->new( pretty_print => 'record');
    $parser->parse($xml);

    return $parser->sprint;
}
