package My::SVN::Builder;

use base 'Module::Build';

use Cwd;

sub _run {
    my($prog, @args) = @_;
    
    return system($prog, @args) == 0 ? 1 : 0;
}

my $Orig_CWD = cwd;
sub _chdir_to_svn {
    chdir 'src/subversion-1.4.5' or die $!;
}

sub _chdir_back {
    chdir $Orig_CWD;
}

sub ACTION_code {
    my $self = shift;
    
    $self->SUPER::ACTION_code;
    $self->_build_svn_core;
}

sub _build_svn_core {
    my $self = shift;
    
    _chdir_to_svn;
    
    _run("./configure")     or do { warn "configuring SVN failed";      return 0 };
    _run("make swig-pl")    or dp { warn "building SVN::Core failed";   return 0 };
    
    _chdir_back;
    
    return 1;
}

sub ACTION_test {
    my $self = shift;
    
    _chdir_to_svn;
    
    my $test_status = _run("make check-swig-pl");
    
    _chdir_back;
    
    return $test_status;
}

sub ACTION_install {
    my $self = shift;
    
    _chdir_to_svn;
    
    _run("make install-swig-pl") or do { warn "installing SVN::Core failed";  return 0 };
    
    _chdir_back;
    
    $self->SUPER::ACTION_install;
}

1;

