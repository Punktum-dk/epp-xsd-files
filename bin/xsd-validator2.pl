#!/usr/bin/env perl

use strict;
use warnings;
use XML::Validate::Xerces;
use Try::Tiny;
use Data::Dumper; # dumper

die "Syntax: $0  <xml-file>  <xsd-file>\n"  unless @ARGV>=2;
my($xml_file, $xsd_file) = @ARGV;

open FIN, '<', $xml_file
    or die "Unable to open file: $xml_file - $!";
my $xml = join '', <FIN>;
close FIN;

if (validate_xml_against_xsd($xml, $xsd_file)) {
    print "XML is adhering to XSD\n";
} else {
    print "XML is NOT adhering to XSD, please see the error\n";
}

print STDERR "Done...\n";

exit 0;

sub validate_xml_against_xsd {
    my ($xml, $xsd_file) = @_;

    try {
        local($SIG{__DIE__});

        my $validator = new XML::Validate::Xerces({
            uri => $xsd_file,
        });

        if (my $doc = $validator->validate($xml)) {
            print "Document is valid\n";
        } else {
            die;
        }

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
