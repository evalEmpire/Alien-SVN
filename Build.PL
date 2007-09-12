#!/usr/bin/perl -w

BEGIN { our $NO_INIT = 1 }

use strict;
use lib "lib", "inc";
use My::Build;

our $TYPE;

# new_from_context is broken: it does not restore
# @INC set in Build.PL before trying to load a base class not
# defined using ->subclass...
my $class = Module::Build->subclass
  ( class            => 'My::Build::new_from_context_is_broken',
    code             => <<'EOC' );
use lib qw(lib inc);
@ISA = qw(My::Build Module::Build);
require My::Build;
EOC
my $build = $class->new
  ( module_name     => 'Alien::wxWidgets',
    license         => 'perl',
    author          => 'Mattia Barbon <mbarbon@cpan.org>',
    requires        => { perl                             => '5.006',
                         'Module::Pluggable'              => '2.6',
                        },
    build_requires  => { 'Module::Build'                  => '0.26',
                         },
    get_options     => { debug      => { type => '!' },
                         unicode    => { type => '!' },
                         mslu       => { type => '!' },
                         static     => { type => '!' },
                         monolithic => { type => '!' },
                         universal  => { type => '!' },
                         build_wx   => { type => '!' },
                         build_wx_opengl => { type => '!' },
                         source     => { type => '=s' },
                         },
    create_makefile_pl => 'passthrough',
  );

my $build_wx_dflt = 'yes';
my $build_wx_opengl_dflt = 'yes';
if( $^O eq 'MSWin32' && ( $ENV{WXWIN} || $ENV{WXDIR} ) ) {
    $build_wx_dflt = 'no';
} else {
    require My::Build::Base;
    my $wx_config = My::Build::Base->awx_path_search( 'wx-config' );
    if( $wx_config ) {
        my $ans = `wx-config --version`;
        $build_wx_dflt = 'no' if $ans =~ /^2\./;
    }
}
if( $^O ne 'darwin' && $^O ne 'MSWin32' ) {
    $build_wx_opengl_dflt = 'no';
}

my $build_wx = _askyn( $build, 'build_wx',
                       'Do you want to build wxWidgets?', $build_wx_dflt );
$build->notes( 'build_wx' => $build_wx );
if( $build_wx ) {
    $TYPE = _ask( $build, 'source', 'Which archive type?', 'tar.gz' );
    $build->notes( 'build_data' => do 'patches/data' );
}
if( $build_wx ) {
    my $build_wx_opengl = _askyn( $build, 'build_wx_opengl',
                                  'Do you want to include OpenGL support',
                                  $build_wx_opengl_dflt );
    $build->notes( 'build_wx_opengl' => $build_wx_opengl );
}

$build->create_build_script;

sub _askyn {
    my( $build, $arg, $question, $default ) = @_;
    my $res = defined $build->args( $arg )
                  ? $build->args( $arg )
                  : $build->y_n( $question, $default );

    return $res
}

sub _ask {
    my( $build, $arg, $question, $default ) = @_;
    my $res = defined $build->args( $arg )
                  ? $build->args( $arg )
                  : $build->prompt( $question, $default );

    return $res
}
