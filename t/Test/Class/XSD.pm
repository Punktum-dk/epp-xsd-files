package Test::Class::XSD;

# $Id$
# $HeadURL$

use strict;
use warnings;

use base qw(Test::Class);

use Test::Exception; # lives_ok, dies_ok
use Digest::MD5 qw(md5_hex);
use Params::Validate qw(:all);
use Syntax::Keyword::Try; #try
use XML::LibXML; # provides: XML::LibXML::Schema
use XML::Twig;
use Test::More; #skip
use Test::Deep;
use Encode qw(decode);
use Net::IDN::Encode qw(:all); #domain_to_unicode
use FindBin qw($Bin);
use HTTP::Status qw(:constants);
use Data::Dumper;
use Term::ANSIColor;
use English; # $PROCESS_ID
use Sub::Override;
use JSON;

sub xml_files : Tests {
    my $self = shift;
    my @files = map { s/[\n\r]//gr } `find xml -name '*.xml'`;

    $self->test_xml_xsd($_, "epp.xsd") foreach @files;
}

sub test_xml_xsd {
    my($self, $xml_file, $xsd_file) = @_;
    $xsd_file //= 'epp.xsd';
    my $should_fail = $xml_file =~ m#/fail/#;
    my $test = sprintf('Testing XSD "%s" on XML "%s"%s', $xsd_file, $xml_file, $should_fail ? ' (should fail)' : '');
#   note $test;
    my($valid, $message) = (0, "-");
    my($xml, $schema);
    try {
        local($SIG{__DIE__});
        $xml    = XML::LibXML->load_xml(    location => $xml_file );
        $schema = XML::LibXML::Schema->new( location => $xsd_file );
        $schema->validate( $xml );
        ($valid, $message) = (1, "OK");
    }
    catch($error) {
        ($valid, $message) = (0, $error);
    }

    $valid = ! $valid   if $should_fail;

    ok($valid, sprintf('%s: %s', $test, $message));
}

sub toStringPretty {
    my $xml = shift;

    my $parser = XML::Twig->new( pretty_print => 'record');
    $parser->parse($xml);

    return $parser->sprint;
}

1;
