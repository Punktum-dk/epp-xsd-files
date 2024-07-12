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

use Test::Class::XSD;

Test::Class->runtests();
