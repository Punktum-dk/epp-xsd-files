#!/usr/bin/env perl

# Import EPP examples from the epp-service-specification repository into xml/.
#
#   bin/import-spec-examples.pl [--spec ../epp-service-specification] [--ref origin/master]
#
# The specification has its examples as ```xml blocks in README.md and
# Poll-Message-Reference-Guide.md. The blocks listed in @examples below are written to
# xml/rfc or xml/v4, and the v4 ones are converted to xml/v5 with bin/convert-example.pl.
# Blocks are found by section heading (README.md) or poll message text, not by position,
# so new examples in the specification do not move them. Fragments (blocks without an
# <epp> root) are not counted. Existing files are overwritten.
#
# Run it from the repository root and check the result with prove t/runtests.t.

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../local/lib/perl5";
use Getopt::Long;
use XML::LibXML;

require "$Bin/convert-example.pl";

my $spec = '../epp-service-specification';
my $ref  = 'origin/master';
GetOptions('spec=s' => \$spec, 'ref=s' => \$ref)
    or die "Usage: $0 [--spec dir] [--ref git-ref, empty for the working tree]\n";

# file => [README.md section heading, occurrence] or [poll message regex, resData element]
my @examples = (
    'rfc/check_domain_response.xml'             => [heading => 'check domain response'],
    'rfc/update_domain_rem_ds.xml'              => [heading => 'Remove DSRECORDS'],
    'rfc/update_domain_add_ds.xml'              => [heading => 'Add DSRECORDS'],
    'rfc/delete_domain.xml'                     => [heading => 'delete domain request'],
    'rfc/delete_domain_response.xml'            => [heading => 'delete domain response'],
    'rfc/restore_domain.xml'                    => [heading => 'restore domain request'],
    'rfc/restore_domain_response_failed.xml'    => [heading => 'restore domain response', 1],
    'rfc/restore_domain_response.xml'           => [heading => 'restore domain response', 2],
    'rfc/transfer_domain.xml'                   => [heading => 'transfer domain request'],
    'rfc/transfer_domain_response.xml'          => [heading => 'transfer domain response'],
    'rfc/create_contact_response.xml'           => [heading => 'Smart creation (auto)'],
    'rfc/poll_contact_email_confirmed.xml'      => [poll => qr/has confirmed the new primary email/],
    'rfc/poll_domain_registered.xml'            => [poll => qr/has been registered and activated/],
    'rfc/poll_domain_transferred_in.xml'        => [poll => qr/has been added to your portfolio/],
    'rfc/poll_host_registered.xml'              => [poll => qr/^The name server \S+ has been registered/],
    'rfc/poll_host_deleted.xml'                 => [poll => qr/^The name server \S+ has been deleted/, 'host:infData'],
    'v4/info_domain_response_domain_advisory.xml'      => [heading => 'info domain response with domain advisory'],
    'v4/info_domain_response_pending_delete.xml'       => [heading => 'info domain response for domain with pending delete'],
    'v4/update_domain_change_registrant_with_token.xml' => [heading => 'change registrant'],
    'v4/poll_contact_updated.xml'               => [poll => qr/^The contact information has been updated/],
    'v4/poll_contact_confirm_email.xml'         => [poll => qr/has to confirm the new primary email/],
    'v4/poll_contact_confirm_secondary_email.xml' => [poll => qr/has to confirm new secondary email/],
    'v4/poll_domain_updated.xml'                => [poll => qr/^\S+ has been updated$/, 'domain:infData'],
    'v4/poll_domain_deleted.xml'                => [poll => qr/^\S+ has been deleted$/, 'domain:infData'],
    'v4/poll_domain_suspended.xml'              => [poll => qr/has been suspended, as the domain was cancelled/],
);

# v4 examples without a v5 counterpart (dotdk-domain:update has no orderConfirmationToken)
my %v4_only = map { $_ => 1 } qw(v4/update_domain_change_registrant_with_token.xml);

my @readme = blocks('README.md');
my @poll   = blocks('Poll-Message-Reference-Guide.md');
my $failed = 0;

while (my($file, $selector) = splice @examples, 0, 2) {
    my $doc = eval { select_block($selector) };
    if (!$doc) { warn "$file: $@"; $failed++; next }
    EPP::ExampleConvert::write_xml("xml/$file", $doc);
    next unless $file =~ m{^v4/(.*)} && !$v4_only{$file};
    my $v5 = eval { EPP::ExampleConvert::convert(XML::LibXML->load_xml(location => "xml/$file"), 'v5') };
    if (!$v5) { warn "$file: cannot convert to v5: $@"; $failed++; next }
    EPP::ExampleConvert::write_xml("xml/v5/$1", $v5);
}
exit($failed ? 1 : 0);

# The ```xml blocks of a specification file, as { heading, text, doc } where doc is the
# parsed <epp> document, or undef for fragments and blocks that do not parse.
sub blocks {
    my $name = shift;
    my $markdown = length $ref ? `git -C '$spec' show '$ref:$name'` : do {
        open my $fh, '<:raw', "$spec/$name" or die "Cannot read $spec/$name: $!\n";
        local $/; <$fh>;
    };
    die "Cannot read $name from $spec ($ref)\n" unless length($markdown // '');

    my($heading, @blocks) = ('');
    while ($markdown =~ /^(?:#+[ \t]*(.*?)[ \t]*|[ \t]*```xml[ \t]*\n(.*?)^[ \t]*```)[ \t]*$/msg) {
        if (defined $1) { $heading = $1; next }
        my $text = $2;
        # Known typo in the specification: unquoted xmlns:xsi in "transfer domain response"
        $text =~ s{xmlns:xsi=(http://www\.w3\.org/2001/XMLSchema-instance)}{xmlns:xsi="$1"};
        my $doc = eval { XML::LibXML->load_xml(string => $text) };
        $doc = undef if $doc && $doc->documentElement->localname ne 'epp';
        push @blocks, { heading => $heading, text => $text, doc => $doc };
    }
    return @blocks;
}

sub select_block {
    my $selector = shift;
    my($kind, $match, $extra) = @$selector;
    my @found;
    if ($kind eq 'heading') {
        @found = grep { $_->{doc} && $_->{heading} eq $match } @readme;
        my $n = $extra // 1;
        die "no complete <epp> example number $n under the heading '$match'\n" unless $found[$n - 1];
        return $found[$n - 1]{doc};
    }
    for my $block (grep { $_->{doc} } @poll) {
        my $msg = $block->{doc}->findvalue('//*[local-name()="msgQ"]/*[local-name()="msg"]');
        $msg =~ s/^\s+|\s+$//g;
        next unless $msg =~ $match;
        next if $extra && !$block->{doc}->findnodes(resdata_xpath($extra));
        return $block->{doc};
    }
    die "no poll message matching $match" . ($extra ? " with $extra" : '') . "\n";
}

sub resdata_xpath {
    my($prefix, $name) = split /:/, shift;
    return qq{//*[local-name()="resData"]/*[local-name()="$name" and contains(namespace-uri(), ":$prefix-")]};
}
