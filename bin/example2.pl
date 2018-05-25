#!/usr/bin/env perl

use strict;
use warnings;

use XML::SAX::ParserFactory;
use XML::Validator::Schema;

my $xml_file = $ARGV[0];
my $xsd_file = $ARGV[1];

#
# create a new validator object, using foo.xsd
#
my $validator = XML::Validator::Schema->new(file => $xsd_file);

#
# create a SAX parser and assign the validator as a Handler
#
my $parser = XML::SAX::ParserFactory->parser(Handler => $validator);

#
# validate foo.xml against foo.xsd
#
eval { $parser->parse_uri($xml_file) };
die "File failed validation: $@" if $@;
