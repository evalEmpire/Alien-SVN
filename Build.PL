#!/usr/bin/perl -w

use strict;
use lib 'inc';
use My::SVN::Builder;

my $build = My::SVN::Builder->new(
    module_name     => 'Alien::SVN',
    license         => 'perl',
    author          => 'Michael G Schwern <mschwern@cpan.org>',
    requires        => {
        perl                    => '5.8.0',
    },
    build_requires      => {
        'ExtUtils::MakeMaker'   => '6.31',   # for INSTALL_BASE
    },
    configure_requires  => {
        'Module::Build'         => '0.26',
    },

    create_makefile_pl => 'passthrough',
);
$build->create_build_script;

print "\n\nSubversion will now be configured.\n\n";
sleep 1;

$build->_run_svn_configure;

print "\n\nYou should now run ./Build.\n";