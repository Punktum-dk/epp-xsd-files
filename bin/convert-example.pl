#!/usr/bin/env perl

# Convert an EPP example between the dkhm 4.5 extensions (v4) and the dotdk 5.0 extensions (v5).
#
#   bin/convert-example.pl --to v5 xml/v4/poll_domain_updated.xml > xml/v5/poll_domain_updated.xml
#   bin/convert-example.pl --to v4 --output xml/v4/create_host.xml xml/v5/create_host.xml
#
# v4 puts each dkhm element directly in <extension>, v5 wraps them in one dotdk-<object>:<wrapper>
# element per object, where the wrapper is the command (create, update, transfer) or the response
# data (infData, creData). Element names, attribute names (expdate/expDate) and values
# (0/1 and true/false, userType letters, risk_assessment case) are mapped, and other extensions
# such as rgp and secDNS are kept. An element with no counterpart in the other version is an error.
#
# The output is normalised: whitespace-only text is dropped, text is trimmed and it is pretty printed.
# The script can also be loaded with require, see bin/import-spec-examples.pl.

package EPP::ExampleConvert;

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../local/lib/perl5";
use XML::LibXML;
use File::Basename qw(dirname);
use File::Path qw(make_path);
use Getopt::Long;

my $V4 = 'urn:dkhm:params:xml:ns:dkhm-4.5';
my %V5 = map { $_ => "urn:dotdk:params:xml:ns:dotdk-$_-5.0" } qw(contact domain host);

# v4 element => [v5 element, map of v4 value to v5 value]
my %bool     = ('1' => 'true', '0' => 'false', 'true' => 'true', 'false' => 'false');
my %usertype = (C => 'company', P => 'publicOrganization', A => 'association', I => 'individual',
                company => 'company', public_organization => 'publicOrganization',
                association => 'association', individual => 'individual');
my %risk     = (GREEN => 'green', BLUE => 'blue', YELLOW => 'yellow', RED => 'red', 'N/A' => 'notAvailable');
my %map = (
    contact => {
        userType => ['userType', \%usertype], EAN => ['ean'], CVR => ['cvr'], pnumber => ['pNumber'],
        mobilephone => ['mobilePhone'], secondaryEmail => ['secondaryEmail'], management => ['management'],
        sole_proprietorship => ['soleProprietorship', \%bool], contact_validated => ['contactValidated', \%bool],
        contact_verification => ['contactVerification'],
        responsible => ['responsible'], verified_id => ['verifiedId', \%bool], verified_email => ['verifiedEmail', \%bool],
        confirm_email => ['confirmEmail'], confirm_secondary_email => ['confirmSecondaryEmail'],
    },
    domain => {
        registrant_validated => ['registrantValidated', \%bool], autoRenew => ['autoRenew', \%bool], vid => ['vid', \%bool],
        domainAdvisory => ['domainAdvisory'], authInfo => ['authInfo'], orderconfirmationToken => ['orderConfirmationToken'],
        trackingNo => ['trackingNo'], risk_assessment => ['riskAssessment', \%risk],
    },
    host => { requestedNsAdmin => ['requestedNsAdmin'] },
);

# v5 booleans that v4 spells 1/0, all other v4 booleans are true/false
my %v4_numeric_bool = map { $_ => 1 } qw(contactValidated registrantValidated);

# Element order in the v5 wrappers (the union of the sequences in dotdk-<object>-5.0.xsd)
my %order = (
    contact => [qw(userType ean cvr pNumber mobilePhone secondaryEmail management soleProprietorship
                   contactValidated contactVerification updateAddress publicStatus)],
    domain  => [qw(orderConfirmationToken registrantValidated autoRenew vid domainAdvisory trackingNo
                   authInfo riskAssessment suspensionDate waitingListCount)],
    host    => [qw(requestedNsAdmin)],
);

main() unless caller;

sub main {
    my($to, $output);
    GetOptions('to=s' => \$to, 'output|o=s' => \$output) && $to && $to =~ /^v[45]$/ && @ARGV == 1
        or die "Usage: $0 --to v4|v5 [--output file] <xml-file>\n";
    my $doc = convert(XML::LibXML->load_xml(location => $ARGV[0]), $to);
    if ($output) { write_xml($output, $doc) }
    else         { normalise($doc); print $doc->toString(1) }
}

sub convert {
    my($doc, $to) = @_;
    return $to eq 'v5' ? to_v5($doc) : to_v4($doc);
}

# Object (contact, domain or host) and v5 wrapper name of the command or response in $doc.
sub context {
    my $doc = shift;
    my($main) = $doc->findnodes('/*/*/*[local-name()="create" or local-name()="update" or local-name()="transfer"]/*[1]');
    ($main) = $doc->findnodes('/*/*/*[local-name()="resData"]/*[1]') unless $main;
    die "No create, update or transfer command and no resData\n" unless $main;
    my($object) = ($main->namespaceURI // '') =~ /:(contact|domain|host)-1\.0$/
        or die "Not a contact, domain or host command or response\n";
    return ($object, $main->localname);
}

sub extension {
    my $doc = shift;
    my($ext) = $doc->findnodes('/*/*/*[local-name()="extension"]');
    return $ext // die "No extension element\n";
}

sub to_v5 {
    my $doc = shift;
    my($object, $wrapper) = context($doc);
    my $ext = extension($doc);
    my @old = grep { ($_->namespaceURI // '') eq $V4 } $ext->childNodes;
    die "No dkhm-4.5 elements in the extension\n" unless @old;

    my $ns   = $V5{$object};
    my $wrap = $doc->createElementNS($ns, "dotdk-$object:$wrapper");
    my %new;
    for my $el (@old) {
        my $converted = convert_v4_element($doc, $el, $object, $ns);
        push @{ $new{ $converted->localname } }, $converted;
    }
    for my $name (@{ $order{$object} }) {
        $wrap->appendChild($_) for @{ delete $new{$name} // [] };
    }
    die "No v5 position for: @{[ sort keys %new ]}\n" if %new;

    $ext->insertBefore($wrap, $old[0]);
    $ext->removeChild($_) for @old;
    return $doc;
}

sub convert_v4_element {
    my($doc, $el, $object, $ns) = @_;
    my $m = $map{$object}{ $el->localname } or die "No v5 counterpart for dkhm:" . $el->localname . " in a $object\n";
    my $new = $doc->createElementNS($ns, "dotdk-$object:$m->[0]");
    copy_attributes($el, $new, expdate => 'expDate');

    my @kids = child_elements($el);
    if (@kids) {
        $new->appendChild(convert_v4_element($doc, $_, $object, $ns)) for @kids;
        return $new;
    }
    my $value = trim($el->textContent);
    if ($m->[1]) {
        $value = $m->[1]{$value} // die "No v5 value for dkhm:" . $el->localname . " '$value'\n";
    }
    $new->appendText($value) if length $value;
    return $new;
}

sub to_v4 {
    my $doc = shift;
    my($object) = context($doc);
    my $ext = extension($doc);
    my($wrap) = grep { ($_->namespaceURI // '') eq $V5{$object} } $ext->childNodes;
    die "No dotdk-$object-5.0 element in the extension\n" unless $wrap;

    my %reverse = map { $map{$object}{$_}[0] => [$_, $map{$object}{$_}[1]] } keys %{ $map{$object} };
    $ext->insertBefore(convert_v5_element($doc, $_, \%reverse), $wrap) for child_elements($wrap);
    $ext->removeChild($wrap);
    return $doc;
}

sub convert_v5_element {
    my($doc, $el, $reverse) = @_;
    my $r = $reverse->{ $el->localname } or die "No v4 counterpart for " . $el->nodeName . "\n";
    my $new = $doc->createElementNS($V4, "dkhm:$r->[0]");
    copy_attributes($el, $new, expDate => 'expdate');

    my @kids = child_elements($el);
    if (@kids) {
        $new->appendChild(convert_v5_element($doc, $_, $reverse)) for @kids;
        return $new;
    }
    my $value = trim($el->textContent);
    my $values = $r->[1];
    if ($values && $values == \%bool) {
        $value = $bool{$value} // $value;
        $value = $value eq 'true' ? '1' : '0' if $v4_numeric_bool{ $el->localname };
    }
    elsif ($values && !exists $values->{$value}) {    # keep a value v4 also accepts
        my %v4_value;    # v4 value for each v5 value, the longest spelling wins (public_organization over P)
        $v4_value{ $values->{$_} } = $_ for sort { length $a <=> length $b } keys %$values;
        $value = $v4_value{$value} // die "No v4 value for " . $el->nodeName . " '$value'\n";
    }
    $new->appendText($value) if length $value;
    return $new;
}

sub copy_attributes {
    my($from, $to, %rename) = @_;
    for my $attr (grep { $_->isa('XML::LibXML::Attr') } $from->attributes) {
        $to->setAttribute($rename{ $attr->name } // $attr->name, $attr->value);
    }
}

sub child_elements { grep { $_->nodeType == XML_ELEMENT_NODE } shift->childNodes }

# Drop whitespace-only text and trim the rest, so toString(1)/toFile(..., 1) can indent.
sub normalise {
    my $doc = shift;
    for my $text ($doc->findnodes('//text()')) {
        if ($text->data =~ /^\s*$/) { $text->unbindNode; next }
        $text->setData(trim($text->data));
    }
    return $doc;
}

sub write_xml {
    my($file, $doc) = @_;
    normalise($doc);
    make_path(dirname($file));
    $doc->toFile($file, 1) or die "Cannot write $file\n";
    print "wrote $file\n";
}

sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s }

1;
