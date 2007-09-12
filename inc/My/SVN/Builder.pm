package My::SVN::Builder;

use base 'Module::Build';

use Cwd;

sub _run {
    my($prog, @args) = @_;
    
    print "Running $prog @args\n";
    return system($prog, @args) == 0 ? 1 : 0;
}

my $Orig_CWD = cwd;
sub _chdir_to_svn {
    chdir 'src/subversion-1.4.5' or die $!;
}

sub _chdir_to_native {
    _chdir_to_svn;
    chdir "subversion/bindings/swig/perl/native" or die $!;
}

sub _chdir_back {
    chdir $Orig_CWD;
}


my %build_to_makemaker = (
   # Some names they have in common
   map {lc($_) => $_} qw(DESTDIR PREFIX INSTALL_BASE UNINST INSTALLDIRS),
);

my %translate_values = (
    installdirs     => {
        core    => "perl",
        site    => 'site',
        vendor  => 'vendor'
    }
);

sub _makemaker_args {
    my $self = shift;

    my $props = $self->{properties};
    my %mm_args;

    for my $key (keys %build_to_makemaker) {
        next unless defined $props->{$key};
        my $value = $props->{$key};
        $value = $translate_values{$key}{$value} if $translate_values{$key};

        $mm_args{$build_to_makemaker{$key}} = $value;
    }
    
    return map { "$_=$mm_args{$_}" } keys %mm_args;
}

sub _configure_args {
    my $self = shift;

    my $props = $self->{properties};
    my $prefix = $props->{install_base} || $props->{prefix};
    
    return() unless $prefix;
    return "--prefix=$prefix";
}

sub _run_svn_configure {
    my $self = shift;
    
    _chdir_to_svn;
    
    _run("./configure", $self->_configure_args)
        or do { warn "configuring SVN failed";      return 0 };
    
    _chdir_back;
}

sub ACTION_code {
    my $self = shift;
    
    $self->SUPER::ACTION_code;

    _chdir_to_svn;

    _run("make swig-pl-lib")
        or do { warn "building swig-pl-lib failed"; return 0 };

    _chdir_back;
    _chdir_to_native;

    _run("perl", "Makefile.PL", $self->_makemaker_args)
        or do { warn "running Makefile.PL failed"; return 0 };
    _run("make") or do { warn "building SV::Core failed"; return 0 };
    
    _chdir_back;
    _chdir_to_svn;
    
    _run("make swig-pl")
        or do { warn "building swig-pl failed"; return 0 };
    
    _chdir_back;
    
    return 1;
}


sub ACTION_test {
    my $self = shift;
    
    _chdir_to_native;
    
    my $test_status = _run("make test");
    
    _chdir_back;
    
    return $test_status;
}


sub ACTION_install {
    my $self = shift;
    
    _chdir_to_svn;

    _run("make install-swig-pl-lib")
        or do { warn "installing swig-pl-lib failed"; return 0 };

    _chdir_back;
    _chdir_to_native;
    
    _run("make install")
        or do { warn "installing SVN::Core failed"; return 0 };
    
    _chdir_back;
    
    $self->SUPER::ACTION_install;
}

1;

