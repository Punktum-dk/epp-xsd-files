#!/usr/bin/env perl

use strict;
use warnings;
use XML::LibXML; # provides: XML::LibXML::Schema
use XML::Twig;
use Try::Tiny;
use Data::Dumper; # dumper

die "Syntax: $0  <xml-file>  <xsd-file>\n"  unless @ARGV>=2;
my($xml_file, $xsd_file) = @ARGV;

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

        print STDERR Data::Dumper->new([{
            epp_error_message => 'XSD Validation failed '. $error,
            epp_status_code   => 2001,
            failed_xml => toStringPretty($xml),
        }])->Sortkeys(1)->Dump;

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
