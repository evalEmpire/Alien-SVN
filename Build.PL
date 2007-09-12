#!/usr/bin/perl -w

use strict;
use lib 'inc';
use My::SVN::Builder;

my $build = My::SVN::Builder->new(
    module_name     => 'Alien::SVN',
    license         => 'perl',
    author          => 'Michael G Schwern <mschwern@cpan.org>',
    requires        => {
    },
    build_requires  => {
        'Module::Build'         => '0.26',
        'Test::More'            => '0.40',
    },

    create_makefile_pl => 'passthrough',
);
$build->create_build_script;

