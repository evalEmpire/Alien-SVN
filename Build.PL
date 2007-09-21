#!/usr/bin/perl -w

use strict;

use lib 'inc';
use My::SVN::Builder;

use Config;

my $build = My::SVN::Builder->new(
    module_name     => 'Alien::SVN',
    license         => 'perl',
    author          => 'Michael G Schwern <schwern@pobox.com>',
    requires        => {
        perl                    => '5.8.0',
    },
    build_requires      => {
        'ExtUtils::MakeMaker'   => '6.31',   # for INSTALL_BASE
        'Test::More'            => '0.40',
    },
    configure_requires  => {
        'Module::Build'         => '0.28',
        'Config'                => 0,
    },

    no_index => {
        directory => [qw(inc src)]
    },

    meta_merge => {
        provides => My::SVN::Builder->_svn_provides(),
    },
);
$build->create_build_script;

print <<'END';

---------------------------------------------------------------------
This module will build Subversion and install it's libraries and Perl
bindings for you.

It requires a C compiler and make.
END

$build->{your_make} = $build->prompt(
    "Which make should I use to build Subversion?",
    $Config{make}
);

my $run_configure = 'y';
if( -e 'src/subversion-1.4.5/config.status' ) {
    $run_configure = $build->prompt(
        "Looks like Subversion has already been configured.\n".
        "Do you want to re-run configure?",
        "n"
    );
}
else {
    $run_configure = $build->prompt(
        "Run Subversion's configure now?",
        $ENV{PERL_RELEASING} ? 'n' : 'y'
    );
}

if( $run_configure =~ /^y/i ) {
    print "\n\nSubversion will now be configured.\n\n";
    sleep 1;

    if( $build->_run_svn_configure ) {
        print "\n\nYou should now run ./Build.\n";
    }
    else {
        print <<'END';
    Something went wrong with the Subversion configuration.
    You should correct it and re-run Build.PL.
END
    }
}
