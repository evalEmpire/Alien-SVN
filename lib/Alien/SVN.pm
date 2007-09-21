package Alien::SVN;

use version;  our $VERSION = qw(1.4.5.1);

=head1 NAME

Alien::SVN - A wrapper for installing the SVN Perl bindings

=head1 DESCRIPTION

Alien::SVN is a wrapper to install the Perl bindings for subversion, also known as L<SVN::Core>.  If your module needs L<SVN::Core> it can depend on L<Alien::SVN> instead and then the CPAN shell can handle automatic installation.

It comes with a copy of Subversion 1.4.5 which it will compile but only installs the Perl and Subversion libraries.  B<The subversion binaries will not be installed>.

=head1 LICENSE

Alien::SVN is copyright 2007 Michael G Schwern <schwern@pobox.com> and is
licensed under the same terms as Perl itself.  See L<http://www.perl.com/perl/misc/Artistic.html> for licensing.

Subversion and SVN::Core are copyright (c) 2000-2006 CollabNet (http://www.colabnet.net).
All rights reserved.  See L<http://subversion.tigris.org/license-1.html> for licensing.

=cut

1;
