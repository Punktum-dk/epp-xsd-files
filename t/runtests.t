#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use lib $Bin, "$Bin/../lib", "$Bin/../local/lib/perl5", <$Bin/../local/lib/perl5/[a-z]*/>, <$Bin/../local/lib/perl5/[a-z]*/auto/>;
binmode STDOUT, ':encoding(UTF-8)';
binmode STDERR, ':encoding(UTF-8)';
use File::Basename 'dirname';
use File::Spec;

use Env qw($MOJO_MODE);
use Getopt::Long;

# --skip-unknown-ns (or XSD_SKIP_UNKNOWN_NS=1) skips examples using namespaces epp.xsd does not load.
# With prove: prove t/runtests.t :: --skip-unknown-ns
GetOptions('skip-unknown-ns' => sub { $ENV{XSD_SKIP_UNKNOWN_NS} = 1 })
    or die "Usage: $0 [--skip-unknown-ns]\n";

use Test::Class::XSD;

Test::Class->runtests();
